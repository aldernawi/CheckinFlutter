import 'dart:async';

import 'package:checkin_flutter/core/config/app_environment.dart';
import 'package:checkin_flutter/core/constants/app_constants.dart';
import 'package:checkin_flutter/core/logging/app_logger.dart';
import 'package:checkin_flutter/core/network/auth_session_manager.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:checkin_flutter/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: AppEnvironment.apiBaseUrl,
    connectTimeout: AppConstants.networkTimeout,
    receiveTimeout: AppConstants.networkTimeout,
    sendTimeout: AppConstants.networkTimeout,
  );

  final dio = Dio(options);
  dio.interceptors.add(PrettyDioLogger(requestBody: true, responseBody: false));
  dio.interceptors.add(AuthInterceptor(ref));
  return dio;
});

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T? Function(Object? value)? converter,
  }) {
    return _execute<T>(
      () => _dio.get(path, queryParameters: queryParameters),
      converter,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T? Function(Object? value)? converter,
  }) {
    return _execute<T>(
      () => _dio.post(path, data: data, queryParameters: queryParameters),
      converter,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    T? Function(Object? value)? converter,
  }) {
    return _execute<T>(() => _dio.put(path, data: data), converter);
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Object? data,
    T? Function(Object? value)? converter,
  }) {
    return _execute<T>(() => _dio.delete(path, data: data), converter);
  }

  Future<ApiResponse<T>> _execute<T>(
    Future<Response<dynamic>> Function() request,
    T? Function(Object? value)? converter,
  ) async {
    try {
      final response = await request();
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ApiResponse.fromJson(data, converter);
      }

      return ApiResponse<T>(
        success: false,
        error: ApiError(code: 'INVALID_RESPONSE', message: 'Invalid API payload'),
      );
    } on DioException catch (error, stackTrace) {
      AppLogger.instance.error('API call failed', error, stackTrace);
      final payload = error.response?.data;
      if (payload is Map<String, dynamic>) {
        return ApiResponse.fromJson(payload, converter);
      }

      return ApiResponse<T>(
        success: false,
        error: ApiError(
          code: error.response?.statusCode?.toString() ?? 'NETWORK_ERROR',
          message: error.message,
        ),
      );
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.ref);

  final Ref ref;
  Completer<bool>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = ref.read(secureStorageServiceProvider);
    final token = await storage.read(StorageKeys.accessToken);

    if (token?.isNotEmpty == true) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshToken();
    if (!refreshed) {
      await ref.read(authSessionProvider.notifier).expireSession();
      handler.next(err);
      return;
    }

    final request = err.requestOptions;
    final storage = ref.read(secureStorageServiceProvider);
    final token = await storage.read(StorageKeys.accessToken);

    if (token?.isNotEmpty == true) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await ref.read(dioProvider).fetch(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<bool> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    final completer = _refreshCompleter!;

    try {
      final storage = ref.read(secureStorageServiceProvider);
      final refreshToken = await storage.read(StorageKeys.refreshToken);
      final accessToken = await storage.read(StorageKeys.accessToken);

      if (refreshToken?.isEmpty ?? true) {
        completer.complete(false);
        return completer.future;
      }

      final response = await ref.read(dioProvider).post(
            'api/v1/auth/refresh',
            data: {
              'accessToken': accessToken ?? '',
              'refreshToken': refreshToken,
            },
            options: Options(headers: {'Authorization': null}),
          );

      final payload = response.data;
      if (payload is! Map<String, dynamic>) {
        completer.complete(false);
        return completer.future;
      }

      final parsed = ApiResponse.fromJson(
        payload,
        (value) => value as Map<String, dynamic>?,
      );

      final data = parsed.data;
      final newAccessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;

      if (parsed.success &&
          newAccessToken?.isNotEmpty == true &&
          newRefreshToken?.isNotEmpty == true) {
        await storage.write(StorageKeys.accessToken, newAccessToken!);
        await storage.write(StorageKeys.refreshToken, newRefreshToken!);
        completer.complete(true);
        return completer.future;
      }

      completer.complete(false);
      return completer.future;
    } catch (_) {
      completer.complete(false);
      return completer.future;
    } finally {
      _refreshCompleter = null;
    }
  }
}

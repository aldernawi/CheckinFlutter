import 'package:checkin_flutter/core/models/store_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:checkin_flutter/core/network/api_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoresRepository {
  StoresRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<MyStoresResponse>> getMyStores({
    double? latitude,
    double? longitude,
    String? search,
    bool orderByDistance = false,
    int page = 1,
    int pageSize = 20,
  }) {
    final params = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (latitude != null) params['latitude'] = latitude.toString();
    if (longitude != null) params['longitude'] = longitude.toString();
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (orderByDistance) params['orderByDistance'] = 'true';

    return _apiClient.get<MyStoresResponse>(
      ApiRoutes.myStores,
      queryParameters: params,
      converter: (value) => value is Map<String, dynamic>
          ? MyStoresResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<StoreDto>> getStore(String storeId) {
    return _apiClient.get<StoreDto>(
      ApiRoutes.store(storeId),
      converter: (value) =>
          value is Map<String, dynamic> ? StoreDto.fromJson(value) : null,
    );
  }

  Future<ApiResponse<CreateStoreResponse>> createStore(
    CreateStoreRequest request,
  ) {
    return _apiClient.post<CreateStoreResponse>(
      ApiRoutes.stores,
      data: request.toJson(),
      converter: (value) => value is Map<String, dynamic>
          ? CreateStoreResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<StoreDto>> updateStore(
    String storeId,
    CreateStoreRequest request,
  ) {
    return _apiClient.put<StoreDto>(
      ApiRoutes.store(storeId),
      data: request.toJson(),
      converter: (value) =>
          value is Map<String, dynamic> ? StoreDto.fromJson(value) : null,
    );
  }

  Future<ApiResponse<UnvisitedStoresResponse>> getUnvisitedStores({
    int page = 1,
    int pageSize = 20,
  }) {
    final now = DateTime.now();
    final fromDate = DateTime(now.year, now.month);
    return _apiClient.get<UnvisitedStoresResponse>(
      ApiRoutes.unvisitedStores,
      queryParameters: {
        'fromDate': fromDate.toIso8601String(),
        'toDate': now.toIso8601String(),
        'page': page,
        'pageSize': pageSize,
      },
      converter: (value) => value is Map<String, dynamic>
          ? UnvisitedStoresResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<StoreVisitsResponse>> getStoreVisits(String storeId) {
    return _apiClient.get<StoreVisitsResponse>(
      ApiRoutes.visitHistory,
      queryParameters: {'storeId': storeId, 'page': 1, 'pageSize': 100},
      converter: (value) => value is Map<String, dynamic>
          ? StoreVisitsResponse.fromJson(value)
          : null,
    );
  }
}

final storesRepositoryProvider = Provider<StoresRepository>(
  (ref) => StoresRepository(ref.watch(apiClientProvider)),
);

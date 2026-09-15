import 'package:checkin_flutter/core/models/request_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:checkin_flutter/core/network/api_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestsRepository {
  RequestsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<RequestsListResponse>> getMyRequests({
    RequestStatus? status,
  }) {
    final params = <String, dynamic>{};
    if (status != null) params['status'] = status.value;

    return _apiClient.get<RequestsListResponse>(
      ApiRoutes.myRequests,
      queryParameters: params.isNotEmpty ? params : null,
      converter: (value) => value is Map<String, dynamic>
          ? RequestsListResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<RequestDto>> createRequest(CreateRequestRequest request) {
    return _apiClient.post<RequestDto>(
      ApiRoutes.requests,
      data: request.toJson(),
      converter: (value) =>
          value is Map<String, dynamic> ? RequestDto.fromJson(value) : null,
    );
  }

  Future<ApiResponse<bool>> cancelRequest(String requestId) {
    return _apiClient.post<bool>(
      ApiRoutes.requestCancel(requestId),
      converter: (value) => value is bool ? value : true,
    );
  }
}

final requestsRepositoryProvider = Provider<RequestsRepository>(
  (ref) => RequestsRepository(ref.watch(apiClientProvider)),
);

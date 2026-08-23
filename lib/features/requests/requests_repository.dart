import 'package:checkin_flutter/core/models/request_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestsRepository {
  RequestsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<RequestsListResponse>> getMyRequests({RequestStatus? status}) {
    final params = <String, dynamic>{};
    if (status != null) params['status'] = status.value;

    return _apiClient.get<RequestsListResponse>(
      'api/v1/employees/me/requests',
      queryParameters: params.isNotEmpty ? params : null,
      converter: (value) => value is Map<String, dynamic>
          ? RequestsListResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<RequestDto>> createRequest(CreateRequestRequest request) {
    return _apiClient.post<RequestDto>(
      'api/v1/requests',
      data: request.toJson(),
      converter: (value) =>
          value is Map<String, dynamic> ? RequestDto.fromJson(value) : null,
    );
  }

  Future<ApiResponse<bool>> cancelRequest(String requestId) {
    return _apiClient.post<bool>(
      'api/v1/requests/$requestId/cancel',
      converter: (value) => value is bool ? value : true,
    );
  }
}

final requestsRepositoryProvider = Provider<RequestsRepository>(
  (ref) => RequestsRepository(ref.watch(apiClientProvider)),
);

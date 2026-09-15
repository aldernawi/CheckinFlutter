import 'package:checkin_flutter/core/models/team_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:checkin_flutter/core/network/api_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamRepository {
  TeamRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<TeamAttendanceResponse>> getTeamAttendance(DateTime date) {
    return _apiClient.get<TeamAttendanceResponse>(
      ApiRoutes.teamAttendance,
      queryParameters: {
        'date':
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      },
      converter: (value) => value is Map<String, dynamic>
          ? TeamAttendanceResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<PendingRequestsResponse>> getPendingRequests() {
    return _apiClient.get<PendingRequestsResponse>(
      ApiRoutes.pendingRequests,
      converter: (value) => value is Map<String, dynamic>
          ? PendingRequestsResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<bool>> approveRequest(
    String requestId,
    ApproveRejectRequest request,
  ) {
    return _apiClient.post<bool>(
      ApiRoutes.requestApprove(requestId),
      data: request.toJson(),
      converter: (value) => value is bool ? value : true,
    );
  }

  Future<ApiResponse<bool>> rejectRequest(
    String requestId,
    ApproveRejectRequest request,
  ) {
    return _apiClient.post<bool>(
      ApiRoutes.requestReject(requestId),
      data: request.toJson(),
      converter: (value) => value is bool ? value : true,
    );
  }
}

final teamRepositoryProvider = Provider<TeamRepository>(
  (ref) => TeamRepository(ref.watch(apiClientProvider)),
);

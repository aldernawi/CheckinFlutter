import 'package:checkin_flutter/core/models/history_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryRepository {
  HistoryRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<AttendanceHistoryResponse>> getHistory({
    int page = 1,
    int pageSize = 20,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (fromDate != null) {
      params['fromDate'] =
          '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
    }
    if (toDate != null) {
      params['toDate'] =
          '${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}';
    }

    return _apiClient.get<AttendanceHistoryResponse>(
      'api/v1/attendance/history',
      queryParameters: params,
      converter: (value) => value is Map<String, dynamic>
          ? AttendanceHistoryResponse.fromJson(value)
          : null,
    );
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(ref.watch(apiClientProvider)),
);

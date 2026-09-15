import 'package:checkin_flutter/core/models/history_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:checkin_flutter/core/network/api_routes.dart';
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
    // The official API requires both dates. MAUI defaults to the recent
    // attendance window, so never send the endpoint an incomplete contract.
    final end = toDate ?? DateTime.now();
    final start = fromDate ?? end.subtract(const Duration(days: 30));
    final params = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
      'startDate': _date(start),
      'endDate': _date(end),
    };

    return _apiClient.get<AttendanceHistoryResponse>(
      ApiRoutes.attendanceHistory,
      queryParameters: params,
      converter: (value) => value is Map<String, dynamic>
          ? AttendanceHistoryResponse.fromJson(value)
          : null,
    );
  }

  String _date(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(ref.watch(apiClientProvider)),
);

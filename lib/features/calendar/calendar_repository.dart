import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/core/models/history_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:checkin_flutter/core/network/api_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarRepository {
  CalendarRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<CalendarResponse>> getCalendar(int year, int month) async {
    final from = DateTime(year, month, 1);
    final to = DateTime(year, month + 1, 0);
    final response = await _apiClient.get<AttendanceHistoryResponse>(
      ApiRoutes.attendanceHistory,
      queryParameters: {
        'startDate': _date(from),
        'endDate': _date(to),
        'page': 1,
        'pageSize': 100,
      },
      converter: (value) => value is Map<String, dynamic>
          ? AttendanceHistoryResponse.fromJson(value)
          : null,
    );
    if (!response.success || response.data == null) {
      return ApiResponse(
        success: false,
        error: response.error,
        message: response.message,
      );
    }
    return ApiResponse(
      success: true,
      data: CalendarResponse(
        year: year,
        month: month,
        days: response.data!.items
            .map(
              (record) => CalendarDayDto(
                date: record.date,
                status: record.status,
                checkInTime: record.checkInTime,
                checkOutTime: record.checkOutTime,
                workedMinutes: record.workedMinutes,
                lateMinutes: record.lateMinutes,
              ),
            )
            .toList(),
      ),
    );
  }

  String _date(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

final calendarRepositoryProvider = Provider<CalendarRepository>(
  (ref) => CalendarRepository(ref.watch(apiClientProvider)),
);

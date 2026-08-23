import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarRepository {
  CalendarRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<CalendarResponse>> getCalendar(int year, int month) {
    return _apiClient.get<CalendarResponse>(
      'api/v1/attendance/calendar',
      queryParameters: {'year': year, 'month': month},
      converter: (value) => value is Map<String, dynamic>
          ? CalendarResponse.fromJson(value)
          : null,
    );
  }
}

final calendarRepositoryProvider = Provider<CalendarRepository>(
  (ref) => CalendarRepository(ref.watch(apiClientProvider)),
);

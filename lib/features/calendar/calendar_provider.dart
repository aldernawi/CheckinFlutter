import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/features/calendar/calendar_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CalendarLoadStatus { idle, loading, success, error }

class CalendarState {
  const CalendarState({
    required this.status,
    this.days = const [],
    this.month = 0,
    this.year = 0,
    this.errorMessage,
  });

  final CalendarLoadStatus status;
  final List<CalendarDayDto> days;
  final int month;
  final int year;
  final String? errorMessage;

  CalendarState copyWith({
    CalendarLoadStatus? status,
    List<CalendarDayDto>? days,
    int? month,
    int? year,
    String? errorMessage,
  }) {
    return CalendarState(
      status: status ?? this.status,
      days: days ?? this.days,
      month: month ?? this.month,
      year: year ?? this.year,
      errorMessage: errorMessage,
    );
  }
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier(this._repo) : super(const CalendarState(status: CalendarLoadStatus.idle));

  final CalendarRepository _repo;

  Future<void> loadCalendar(int year, int month) async {
    state = state.copyWith(status: CalendarLoadStatus.loading);
    final response = await _repo.getCalendar(year, month);

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: CalendarLoadStatus.success,
        days: response.data!.days,
        month: response.data!.month,
        year: response.data!.year,
      );
    } else {
      state = state.copyWith(
        status: CalendarLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل التقويم',
      );
    }
  }
}

final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>(
  (ref) => CalendarNotifier(ref.watch(calendarRepositoryProvider)),
);

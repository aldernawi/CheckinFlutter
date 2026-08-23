import 'package:checkin_flutter/core/models/field_visit_models.dart';
import 'package:checkin_flutter/features/field_visits/field_visits_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FieldVisitsLoadStatus { idle, loading, success, error }

class FieldVisitsState {
  const FieldVisitsState({
    required this.status,
    this.summary,
    this.errorMessage,
  });

  final FieldVisitsLoadStatus status;
  final TodayVisitsSummaryDto? summary;
  final String? errorMessage;

  FieldVisitsState copyWith({
    FieldVisitsLoadStatus? status,
    TodayVisitsSummaryDto? summary,
    String? errorMessage,
  }) {
    return FieldVisitsState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }
}

class FieldVisitsNotifier extends StateNotifier<FieldVisitsState> {
  FieldVisitsNotifier(this._repo) : super(const FieldVisitsState(status: FieldVisitsLoadStatus.idle));

  final FieldVisitsRepository _repo;

  Future<void> loadTodayVisits() async {
    state = state.copyWith(status: FieldVisitsLoadStatus.loading);
    final response = await _repo.getTodayVisits();

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: FieldVisitsLoadStatus.success,
        summary: response.data!,
      );
    } else {
      state = state.copyWith(
        status: FieldVisitsLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل الزيارات',
      );
    }
  }

  Future<({bool success, String? error, RecordVisitResponse? data})> recordVisit(
    RecordVisitRequest request,
  ) async {
    final response = await _repo.recordVisit(request);
    if (response.success && response.data != null) {
      await loadTodayVisits();
      return (success: true, error: null, data: response.data);
    }
    return (success: false, error: response.error?.message ?? 'فشل تسجيل الزيارة', data: null);
  }
}

final fieldVisitsProvider = StateNotifierProvider<FieldVisitsNotifier, FieldVisitsState>(
  (ref) => FieldVisitsNotifier(ref.watch(fieldVisitsRepositoryProvider)),
);

enum VisitHistoryLoadStatus { idle, loading, success, error }

class VisitHistoryState {
  const VisitHistoryState({
    required this.status,
    this.items = const [],
    this.totalCount = 0,
    this.errorMessage,
  });

  final VisitHistoryLoadStatus status;
  final List<FieldVisitDto> items;
  final int totalCount;
  final String? errorMessage;

  VisitHistoryState copyWith({
    VisitHistoryLoadStatus? status,
    List<FieldVisitDto>? items,
    int? totalCount,
    String? errorMessage,
  }) {
    return VisitHistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage,
    );
  }
}

class VisitHistoryNotifier extends StateNotifier<VisitHistoryState> {
  VisitHistoryNotifier(this._repo) : super(const VisitHistoryState(status: VisitHistoryLoadStatus.idle));

  final FieldVisitsRepository _repo;

  Future<void> loadHistory({int page = 1, int pageSize = 20}) async {
    state = state.copyWith(status: VisitHistoryLoadStatus.loading);
    final response = await _repo.getMyVisits(page: page, pageSize: pageSize);

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: VisitHistoryLoadStatus.success,
        items: response.data!.items,
        totalCount: response.data!.totalCount,
      );
    } else {
      state = state.copyWith(
        status: VisitHistoryLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل السجل',
      );
    }
  }
}

final visitHistoryProvider = StateNotifierProvider<VisitHistoryNotifier, VisitHistoryState>(
  (ref) => VisitHistoryNotifier(ref.watch(fieldVisitsRepositoryProvider)),
);

import 'package:checkin_flutter/core/models/history_models.dart';
import 'package:checkin_flutter/features/history/history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HistoryLoadStatus { idle, loading, success, error }

class HistoryState {
  const HistoryState({
    required this.status,
    this.items = const [],
    this.totalCount = 0,
    this.currentPage = 1,
    this.errorMessage,
  });

  final HistoryLoadStatus status;
  final List<AttendanceRecordDto> items;
  final int totalCount;
  final int currentPage;
  final String? errorMessage;

  HistoryState copyWith({
    HistoryLoadStatus? status,
    List<AttendanceRecordDto>? items,
    int? totalCount,
    int? currentPage,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier(this._repo) : super(const HistoryState(status: HistoryLoadStatus.idle));

  final HistoryRepository _repo;

  Future<void> loadHistory({int page = 1, DateTime? fromDate, DateTime? toDate}) async {
    state = state.copyWith(status: HistoryLoadStatus.loading);
    final response = await _repo.getHistory(page: page, fromDate: fromDate, toDate: toDate);

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: HistoryLoadStatus.success,
        items: response.data!.items,
        totalCount: response.data!.totalCount,
        currentPage: page,
      );
    } else {
      state = state.copyWith(
        status: HistoryLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل السجل',
      );
    }
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>(
  (ref) => HistoryNotifier(ref.watch(historyRepositoryProvider)),
);

import 'package:checkin_flutter/core/models/team_models.dart';
import 'package:checkin_flutter/features/team/team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TeamLoadStatus { idle, loading, success, error }

class TeamAttendanceState {
  const TeamAttendanceState({
    required this.status,
    this.summary,
    this.items = const [],
    this.errorMessage,
  });

  final TeamLoadStatus status;
  final TeamAttendanceSummary? summary;
  final List<TeamMemberAttendanceDto> items;
  final String? errorMessage;

  TeamAttendanceState copyWith({
    TeamLoadStatus? status,
    TeamAttendanceSummary? summary,
    List<TeamMemberAttendanceDto>? items,
    String? errorMessage,
  }) {
    return TeamAttendanceState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}

class TeamAttendanceNotifier extends StateNotifier<TeamAttendanceState> {
  TeamAttendanceNotifier(this._repo) : super(const TeamAttendanceState(status: TeamLoadStatus.idle));

  final TeamRepository _repo;

  Future<void> loadAttendance(DateTime date) async {
    state = state.copyWith(status: TeamLoadStatus.loading);
    final response = await _repo.getTeamAttendance(date);

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: TeamLoadStatus.success,
        summary: response.data!.summary,
        items: response.data!.items,
      );
    } else {
      state = state.copyWith(
        status: TeamLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل الحضور',
      );
    }
  }
}

final teamAttendanceProvider = StateNotifierProvider<TeamAttendanceNotifier, TeamAttendanceState>(
  (ref) => TeamAttendanceNotifier(ref.watch(teamRepositoryProvider)),
);

enum PendingRequestsLoadStatus { idle, loading, success, error }

class PendingRequestsState {
  const PendingRequestsState({
    required this.status,
    this.items = const [],
    this.errorMessage,
  });

  final PendingRequestsLoadStatus status;
  final List<PendingRequestDto> items;
  final String? errorMessage;

  PendingRequestsState copyWith({
    PendingRequestsLoadStatus? status,
    List<PendingRequestDto>? items,
    String? errorMessage,
  }) {
    return PendingRequestsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}

class PendingRequestsNotifier extends StateNotifier<PendingRequestsState> {
  PendingRequestsNotifier(this._repo) : super(const PendingRequestsState(status: PendingRequestsLoadStatus.idle));

  final TeamRepository _repo;

  Future<void> loadRequests() async {
    state = state.copyWith(status: PendingRequestsLoadStatus.loading);
    final response = await _repo.getPendingRequests();

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: PendingRequestsLoadStatus.success,
        items: response.data!.items,
      );
    } else {
      state = state.copyWith(
        status: PendingRequestsLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل الطلبات',
      );
    }
  }

  Future<bool> approveRequest(String requestId, {String? notes}) async {
    final response = await _repo.approveRequest(
      requestId,
      ApproveRejectRequest(notes: notes),
    );
    if (response.success) {
      await loadRequests();
      return true;
    }
    return false;
  }

  Future<bool> rejectRequest(String requestId, {String? rejectionReason}) async {
    final response = await _repo.rejectRequest(
      requestId,
      ApproveRejectRequest(rejectionReason: rejectionReason),
    );
    if (response.success) {
      await loadRequests();
      return true;
    }
    return false;
  }
}

final pendingRequestsProvider = StateNotifierProvider<PendingRequestsNotifier, PendingRequestsState>(
  (ref) => PendingRequestsNotifier(ref.watch(teamRepositoryProvider)),
);

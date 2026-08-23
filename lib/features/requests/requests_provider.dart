import 'package:checkin_flutter/core/models/request_models.dart';
import 'package:checkin_flutter/features/requests/requests_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RequestsLoadStatus { idle, loading, success, error }

class RequestsState {
  const RequestsState({
    required this.status,
    this.items = const [],
    this.errorMessage,
  });

  final RequestsLoadStatus status;
  final List<RequestDto> items;
  final String? errorMessage;

  RequestsState copyWith({
    RequestsLoadStatus? status,
    List<RequestDto>? items,
    String? errorMessage,
  }) {
    return RequestsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }
}

class RequestsNotifier extends StateNotifier<RequestsState> {
  RequestsNotifier(this._repo) : super(const RequestsState(status: RequestsLoadStatus.idle));

  final RequestsRepository _repo;

  Future<void> loadRequests({RequestStatus? statusFilter}) async {
    state = state.copyWith(status: RequestsLoadStatus.loading);

    final response = await _repo.getMyRequests(status: statusFilter);

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: RequestsLoadStatus.success,
        items: response.data!.items,
      );
    } else {
      state = state.copyWith(
        status: RequestsLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل الطلبات',
      );
    }
  }

  Future<bool> createRequest(CreateRequestRequest request) async {
    final response = await _repo.createRequest(request);

    if (response.success) {
      await loadRequests();
      return true;
    }
    return false;
  }

  Future<bool> cancelRequest(String requestId) async {
    final response = await _repo.cancelRequest(requestId);

    if (response.success) {
      await loadRequests();
      return true;
    }
    return false;
  }
}

final requestsProvider = StateNotifierProvider<RequestsNotifier, RequestsState>(
  (ref) => RequestsNotifier(ref.watch(requestsRepositoryProvider)),
);

import 'package:checkin_flutter/core/models/store_models.dart';
import 'package:checkin_flutter/features/stores/stores_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StoresLoadStatus { idle, loading, success, error }

class StoresState {
  const StoresState({
    required this.status,
    this.stores = const [],
    this.totalCount = 0,
    this.errorMessage,
  });

  final StoresLoadStatus status;
  final List<StoreListItemDto> stores;
  final int totalCount;
  final String? errorMessage;

  StoresState copyWith({
    StoresLoadStatus? status,
    List<StoreListItemDto>? stores,
    int? totalCount,
    String? errorMessage,
  }) {
    return StoresState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage,
    );
  }
}

class StoresNotifier extends StateNotifier<StoresState> {
  StoresNotifier(this._repo) : super(const StoresState(status: StoresLoadStatus.idle));

  final StoresRepository _repo;

  Future<void> loadStores({
    double? latitude,
    double? longitude,
    String? search,
    bool orderByDistance = false,
    int page = 1,
    int pageSize = 50,
  }) async {
    state = state.copyWith(status: StoresLoadStatus.loading);
    final response = await _repo.getMyStores(
      latitude: latitude,
      longitude: longitude,
      search: search,
      orderByDistance: orderByDistance,
      page: page,
      pageSize: pageSize,
    );

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: StoresLoadStatus.success,
        stores: response.data!.stores,
        totalCount: response.data!.totalCount,
      );
    } else {
      state = state.copyWith(
        status: StoresLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل المحلات',
      );
    }
  }
}

final storesProvider = StateNotifierProvider<StoresNotifier, StoresState>(
  (ref) => StoresNotifier(ref.watch(storesRepositoryProvider)),
);

enum UnvisitedLoadStatus { idle, loading, success, error }

class UnvisitedState {
  const UnvisitedState({
    required this.status,
    this.items = const [],
    this.totalCount = 0,
    this.errorMessage,
  });

  final UnvisitedLoadStatus status;
  final List<UnvisitedStoreDto> items;
  final int totalCount;
  final String? errorMessage;

  UnvisitedState copyWith({
    UnvisitedLoadStatus? status,
    List<UnvisitedStoreDto>? items,
    int? totalCount,
    String? errorMessage,
  }) {
    return UnvisitedState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage,
    );
  }
}

class UnvisitedNotifier extends StateNotifier<UnvisitedState> {
  UnvisitedNotifier(this._repo) : super(const UnvisitedState(status: UnvisitedLoadStatus.idle));

  final StoresRepository _repo;

  Future<void> loadUnvisited({int page = 1, int pageSize = 50}) async {
    state = state.copyWith(status: UnvisitedLoadStatus.loading);
    final response = await _repo.getUnvisitedStores(page: page, pageSize: pageSize);

    if (response.success && response.data != null) {
      state = state.copyWith(
        status: UnvisitedLoadStatus.success,
        items: response.data!.items,
        totalCount: response.data!.totalCount,
      );
    } else {
      state = state.copyWith(
        status: UnvisitedLoadStatus.error,
        errorMessage: response.error?.message ?? 'فشل تحميل المحلات غير المُزار',
      );
    }
  }
}

final unvisitedStoresProvider = StateNotifierProvider<UnvisitedNotifier, UnvisitedState>(
  (ref) => UnvisitedNotifier(ref.watch(storesRepositoryProvider)),
);

enum StoreDetailsLoadStatus { idle, loading, success, error }

class StoreDetailsState {
  const StoreDetailsState({
    required this.status,
    this.store,
    this.visits = const [],
    this.errorMessage,
  });

  final StoreDetailsLoadStatus status;
  final StoreDto? store;
  final List<StoreVisitDto> visits;
  final String? errorMessage;

  StoreDetailsState copyWith({
    StoreDetailsLoadStatus? status,
    StoreDto? store,
    List<StoreVisitDto>? visits,
    String? errorMessage,
  }) {
    return StoreDetailsState(
      status: status ?? this.status,
      store: store ?? this.store,
      visits: visits ?? this.visits,
      errorMessage: errorMessage,
    );
  }
}

class StoreDetailsNotifier extends StateNotifier<StoreDetailsState> {
  StoreDetailsNotifier(this._repo) : super(const StoreDetailsState(status: StoreDetailsLoadStatus.idle));

  final StoresRepository _repo;

  Future<void> loadStore(String storeId) async {
    state = state.copyWith(status: StoreDetailsLoadStatus.loading);

    final storeResponse = await _repo.getStore(storeId);
    final visitsResponse = await _repo.getStoreVisits(storeId);

    if (storeResponse.success && storeResponse.data != null) {
      state = state.copyWith(
        status: StoreDetailsLoadStatus.success,
        store: storeResponse.data!,
        visits: visitsResponse.success && visitsResponse.data != null
            ? visitsResponse.data!.items
            : const [],
      );
    } else {
      state = state.copyWith(
        status: StoreDetailsLoadStatus.error,
        errorMessage: storeResponse.error?.message ?? 'فشل تحميل تفاصيل المحل',
      );
    }
  }
}

final storeDetailsProvider = StateNotifierProvider<StoreDetailsNotifier, StoreDetailsState>(
  (ref) => StoreDetailsNotifier(ref.watch(storesRepositoryProvider)),
);

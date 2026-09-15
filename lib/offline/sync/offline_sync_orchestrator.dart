import 'dart:async';

import 'package:checkin_flutter/core/connectivity/connectivity_service.dart';
import 'package:checkin_flutter/core/logging/app_logger.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_routes.dart';
import 'package:checkin_flutter/offline/queue/offline_queue_item.dart';
import 'package:checkin_flutter/offline/queue/offline_queue_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineSyncOrchestrator {
  OfflineSyncOrchestrator(
    this._queueRepository,
    this._connectivityService,
    this._apiClient,
  );

  final OfflineQueueRepository _queueRepository;
  final ConnectivityService _connectivityService;
  final ApiClient _apiClient;
  StreamSubscription<List<dynamic>>? _connectivitySubscription;

  Future<void> start() async {
    _connectivitySubscription ??= _connectivityService.onNetworkChanged.listen((
      _,
    ) async {
      final hasInternet = await _connectivityService.hasInternet();
      if (hasInternet) {
        await syncPending();
      }
    });
  }

  Future<void> stop() async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  Future<void> syncPending() async {
    final hasInternet = await _connectivityService.hasInternet();
    if (!hasInternet) {
      return;
    }

    final pendingItems = await _queueRepository.pending();
    for (final item in pendingItems) {
      await _syncSingle(item);
    }
  }

  Future<void> _syncSingle(OfflineQueueItem item) async {
    try {
      await _queueRepository.update(
        item.copyWith(status: OfflineQueueStatus.syncing),
      );
      final response = await _apiClient.post<Map<String, dynamic>>(
        _routeFor(item.operation),
        data: item.payload,
        converter: (value) => value is Map<String, dynamic> ? value : const {},
      );
      if (!response.success) {
        throw StateError(response.error?.message ?? 'Offline replay failed');
      }
      await _queueRepository.update(
        item.copyWith(status: OfflineQueueStatus.synced),
      );
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Offline sync failed for ${item.id}',
        error,
        stackTrace,
      );
      await _queueRepository.update(
        item.copyWith(
          status: OfflineQueueStatus.failed,
          retryCount: item.retryCount + 1,
          nextRetryAt: DateTime.now().add(
            Duration(minutes: 1 << item.retryCount.clamp(0, 5).toInt()),
          ),
        ),
      );
    }
  }

  String _routeFor(String operation) {
    switch (operation) {
      case 'attendance.checkin':
        return ApiRoutes.attendanceCheckin;
      case 'attendance.checkout':
        return ApiRoutes.attendanceCheckout;
      case 'visits.record':
        return ApiRoutes.visits;
      default:
        throw ArgumentError.value(
          operation,
          'operation',
          'Unsupported offline operation',
        );
    }
  }
}

final offlineSyncOrchestratorProvider = Provider<OfflineSyncOrchestrator>(
  (ref) => OfflineSyncOrchestrator(
    ref.watch(offlineQueueRepositoryProvider),
    ref.watch(connectivityServiceProvider),
    ref.watch(apiClientProvider),
  ),
);

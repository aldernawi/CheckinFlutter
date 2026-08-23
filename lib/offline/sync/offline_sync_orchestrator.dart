import 'dart:async';

import 'package:checkin_flutter/core/connectivity/connectivity_service.dart';
import 'package:checkin_flutter/core/logging/app_logger.dart';
import 'package:checkin_flutter/offline/queue/offline_queue_item.dart';
import 'package:checkin_flutter/offline/queue/offline_queue_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineSyncOrchestrator {
  OfflineSyncOrchestrator(this._queueRepository, this._connectivityService);

  final OfflineQueueRepository _queueRepository;
  final ConnectivityService _connectivityService;
  StreamSubscription<List<dynamic>>? _connectivitySubscription;

  Future<void> start() async {
    _connectivitySubscription ??=
        _connectivityService.onNetworkChanged.listen((_) async {
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
      await _queueRepository.update(item.copyWith(status: OfflineQueueStatus.syncing));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await _queueRepository.update(item.copyWith(status: OfflineQueueStatus.synced));
    } catch (error, stackTrace) {
      AppLogger.instance.error('Offline sync failed for ${item.id}', error, stackTrace);
      await _queueRepository.update(
        item.copyWith(
          status: OfflineQueueStatus.failed,
          retryCount: item.retryCount + 1,
          nextRetryAt: DateTime.now().add(const Duration(minutes: 2)),
        ),
      );
    }
  }
}

final offlineSyncOrchestratorProvider = Provider<OfflineSyncOrchestrator>(
  (ref) => OfflineSyncOrchestrator(
    ref.watch(offlineQueueRepositoryProvider),
    ref.watch(connectivityServiceProvider),
  ),
);

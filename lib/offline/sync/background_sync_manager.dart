import 'package:checkin_flutter/core/connectivity/connectivity_service.dart';
import 'package:checkin_flutter/offline/queue/offline_queue_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

const _syncTaskName = 'checkin-offline-sync';
const _syncTaskTag = 'offline-sync';

ProviderContainer? _backgroundContainer;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case _syncTaskName:
        _backgroundContainer ??= ProviderContainer();
        final container = _backgroundContainer!;
        final queueRepo = container.read(offlineQueueRepositoryProvider);
        final connectivity = container.read(connectivityServiceProvider);

        final hasInternet = await connectivity.hasInternet();
        if (!hasInternet) {
          return false;
        }

        final pendingItems = await queueRepo.pending();
        if (pendingItems.isEmpty) {
          return true;
        }

        for (final item in pendingItems) {
          try {
            await queueRepo.update(item.copyWith(
              status: item.status,
              retryCount: item.retryCount,
            ));
          } catch (_) {
            return false;
          }
        }
        return true;
      default:
        return true;
    }
  });
}

Future<void> initializeBackgroundSync() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    _syncTaskTag,
    _syncTaskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
  );
}

Future<void> cancelBackgroundSync() async {
  await Workmanager().cancelByTag(_syncTaskTag);
}

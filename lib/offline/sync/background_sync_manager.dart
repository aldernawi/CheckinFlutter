import 'package:checkin_flutter/offline/sync/offline_sync_orchestrator.dart';
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
        await container.read(offlineSyncOrchestratorProvider).syncPending();
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
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
  );
}

Future<void> cancelBackgroundSync() async {
  await Workmanager().cancelByTag(_syncTaskTag);
}

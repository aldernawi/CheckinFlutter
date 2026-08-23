import 'package:checkin_flutter/offline/sync/offline_sync_orchestrator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final offlineSyncBootstrapProvider = Provider<void>((ref) {
  final orchestrator = ref.watch(offlineSyncOrchestratorProvider);
  orchestrator.start();
  ref.onDispose(orchestrator.stop);
});

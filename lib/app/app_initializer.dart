import 'package:checkin_flutter/core/network/auth_session_manager.dart';
import 'package:checkin_flutter/offline/sync/offline_sync_bootstrap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appInitializationProvider = FutureProvider<void>((ref) async {
  ref.watch(offlineSyncBootstrapProvider);
  await ref.read(authSessionProvider.notifier).bootstrap();
});

import 'dart:async';

import 'package:checkin_flutter/app/app.dart';
import 'package:checkin_flutter/core/logging/app_logger.dart';
import 'package:checkin_flutter/offline/sync/background_sync_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () async {
      await initializeBackgroundSync();
      runApp(const ProviderScope(child: CheckinApp()));
    },
    (error, stackTrace) {
      AppLogger.instance.error('Uncaught zone error', error, stackTrace);
    },
  );
}

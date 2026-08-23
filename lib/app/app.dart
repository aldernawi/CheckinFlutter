import 'package:checkin_flutter/app/app_initializer.dart';
import 'package:checkin_flutter/app/router/app_router.dart';
import 'package:checkin_flutter/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckinApp extends ConsumerWidget {
  const CheckinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialization = ref.watch(appInitializationProvider);

    if (initialization.isLoading) {
      return MaterialApp(
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (initialization.hasError) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Initialization error: ${initialization.error}'),
          ),
        ),
      );
    }

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Checkin Libya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

enum AppFlavor { dev, staging, prod }

class AppEnvironment {
  const AppEnvironment._();

  static AppFlavor get flavor {
    // A release build must never silently target the emulator-only dev URL.
    // Developers can still opt into dev or staging with --dart-define=FLAVOR=...
    const value = String.fromEnvironment('FLAVOR', defaultValue: 'prod');
    switch (value) {
      case 'prod':
        return AppFlavor.prod;
      case 'staging':
        return AppFlavor.staging;
      default:
        return AppFlavor.dev;
    }
  }

  static String get apiBaseUrl {
    switch (flavor) {
      case AppFlavor.prod:
        return 'https://checkin.nmc.ly/';
      case AppFlavor.staging:
        return 'https://staging.checkin.nmc.ly/';
      case AppFlavor.dev:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://10.0.2.2:7144/',
        );
    }
  }
}

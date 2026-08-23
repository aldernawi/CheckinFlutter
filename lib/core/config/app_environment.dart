enum AppFlavor { dev, staging, prod }

class AppEnvironment {
  const AppEnvironment._();

  static AppFlavor get flavor {
    const value = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
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

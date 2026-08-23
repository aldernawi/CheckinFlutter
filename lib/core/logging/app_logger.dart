import 'dart:developer' as developer;

class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  void info(String message) {
    developer.log(message, name: 'checkin.info');
  }

  void warn(String message) {
    developer.log(message, name: 'checkin.warn', level: 900);
  }

  void error(String message, Object error, StackTrace stackTrace) {
    developer.log(
      message,
      name: 'checkin.error',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}

sealed class AppFailure {
  const AppFailure(this.message, {this.code});

  final String message;
  final String? code;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message, {super.code});
}

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure(super.message, {super.code});
}

final class SessionExpiredFailure extends AppFailure {
  const SessionExpiredFailure(super.message, {super.code});
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message, {super.code});
}

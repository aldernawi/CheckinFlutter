import 'dart:async';

import 'package:checkin_flutter/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppUserRoleSet { employee, manager, fieldRep }

class AuthSessionState {
  const AuthSessionState({
    required this.isAuthenticated,
    required this.roleSet,
  });

  final bool isAuthenticated;
  final AppUserRoleSet roleSet;

  AuthSessionState copyWith({
    bool? isAuthenticated,
    AppUserRoleSet? roleSet,
  }) {
    return AuthSessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      roleSet: roleSet ?? this.roleSet,
    );
  }
}

class AuthSessionNotifier extends StateNotifier<AuthSessionState> {
  AuthSessionNotifier(this._storage)
      : super(const AuthSessionState(
          isAuthenticated: false,
          roleSet: AppUserRoleSet.employee,
        ));

  final SecureStorageService _storage;

  final StreamController<void> _sessionExpiredController =
      StreamController<void>.broadcast();

  Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  Future<void> bootstrap() async {
    final token = await _storage.read(StorageKeys.accessToken);
    state = state.copyWith(isAuthenticated: token?.isNotEmpty == true);
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    AppUserRoleSet roleSet = AppUserRoleSet.employee,
  }) async {
    await _storage.write(StorageKeys.accessToken, accessToken);
    await _storage.write(StorageKeys.refreshToken, refreshToken);

    state = state.copyWith(
      isAuthenticated: true,
      roleSet: roleSet,
    );
  }

  Future<void> logout() async {
    await _storage.clearSession();
    state = state.copyWith(isAuthenticated: false);
  }

  Future<void> expireSession() async {
    await logout();
    _sessionExpiredController.add(null);
  }

  @override
  void dispose() {
    _sessionExpiredController.close();
    super.dispose();
  }
}

final authSessionProvider =
    StateNotifierProvider<AuthSessionNotifier, AuthSessionState>(
  (ref) => AuthSessionNotifier(ref.watch(secureStorageServiceProvider)),
);

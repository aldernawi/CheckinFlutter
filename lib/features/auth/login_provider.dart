import 'package:checkin_flutter/features/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LoginStateStatus { idle, loading, success, error }

class LoginState {
  const LoginState({
    required this.status,
    this.phone = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.errorMessage,
  });

  final LoginStateStatus status;
  final String phone;
  final String password;
  final bool isPasswordVisible;
  final String? errorMessage;

  LoginState copyWith({
    LoginStateStatus? status,
    String? phone,
    String? password,
    bool? isPasswordVisible,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._repository) : super(const LoginState(status: LoginStateStatus.idle));

  final AuthRepository _repository;

  void updatePhone(String value) {
    state = state.copyWith(phone: value, status: LoginStateStatus.idle);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, status: LoginStateStatus.idle);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  bool get canLogin =>
      state.phone.trim().isNotEmpty &&
      state.password.isNotEmpty &&
      state.status != LoginStateStatus.loading;

  Future<bool> login({required String deviceId, String? deviceName}) async {
    if (!canLogin) return false;

    state = state.copyWith(status: LoginStateStatus.loading);

    final result = await _repository.login(
      phone: state.phone,
      password: state.password,
      deviceId: deviceId,
      deviceName: deviceName,
    );

    if (result.success) {
      state = state.copyWith(status: LoginStateStatus.success);
      return true;
    }

    state = state.copyWith(
      status: LoginStateStatus.error,
      errorMessage: result.error ?? 'فشل تسجيل الدخول',
    );
    return false;
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.watch(authRepositoryProvider)),
);

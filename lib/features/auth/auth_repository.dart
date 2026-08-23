import 'package:checkin_flutter/core/models/employee_dto.dart';
import 'package:checkin_flutter/core/models/login_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/auth_session_manager.dart';
import 'package:checkin_flutter/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  AuthRepository(this._apiClient, this._storage, this._sessionNotifier);

  final ApiClient _apiClient;
  final SecureStorageService _storage;
  final AuthSessionNotifier _sessionNotifier;

  Future<({bool success, String? error})> login({
    required String phone,
    required String password,
    required String deviceId,
    String? deviceName,
    String deviceType = 'Android',
  }) async {
    final response = await _apiClient.post<LoginResponse>(
      'api/v1/auth/login',
      data: LoginRequest(
        phone: phone.trim(),
        password: password,
        deviceId: deviceId,
        deviceName: deviceName,
        deviceType: deviceType,
      ).toJson(),
      converter: (value) =>
          value is Map<String, dynamic> ? LoginResponse.fromJson(value) : null,
    );

    if (response.success && response.data != null) {
      final data = response.data!;
      final roleSet = _determineRoleSet(data.employee);
      await _sessionNotifier.saveSession(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
        roleSet: roleSet,
      );
      await _storage.write(
        StorageKeys.employeeData,
        data.employee.toJson().toString(),
      );
      return (success: true, error: null);
    }

    return (success: false, error: response.error?.message ?? 'فشل تسجيل الدخول');
  }

  Future<void> logout() async {
    await _sessionNotifier.logout();
  }

  Future<({bool success, String? error})> forgotPassword(String phone) async {
    final response = await _apiClient.post<bool>(
      'api/v1/auth/forgot-password',
      data: {'phone': phone.trim()},
      converter: (value) => value is bool ? value : true,
    );
    if (response.success) {
      return (success: true, error: null);
    }
    return (success: false, error: response.error?.message ?? 'فشل إرسال طلب إعادة التعيين');
  }

  Future<({bool success, String? error})> selfRegister({
    required String fullName,
    required String phone,
    required String password,
    String? email,
  }) async {
    final response = await _apiClient.post<bool>(
      'api/v1/auth/self-register',
      data: {
        'fullName': fullName.trim(),
        'phone': phone.trim(),
        'password': password,
        if (email != null && email.isNotEmpty) 'email': email.trim(),
      },
      converter: (value) => value is bool ? value : true,
    );
    if (response.success) {
      return (success: true, error: null);
    }
    return (success: false, error: response.error?.message ?? 'فشل إنشاء الحساب');
  }

  AppUserRoleSet _determineRoleSet(EmployeeDto employee) {
    final managerRoles = {'TeamLead', 'Manager', 'BranchManager', 'HR', 'HRManager', 'Admin'};
    final fieldTypes = {2, 3, 4};
    final fieldRoles = {'FieldRep', 'SalesRep', 'DeliveryRep'};

    if (employee.roles.any((r) => managerRoles.contains(r))) {
      return AppUserRoleSet.manager;
    }

    if (employee.employeeType != null && fieldTypes.contains(employee.employeeType)) {
      return AppUserRoleSet.fieldRep;
    }

    if (employee.roles.any((r) => fieldRoles.contains(r))) {
      return AppUserRoleSet.fieldRep;
    }

    return AppUserRoleSet.employee;
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(secureStorageServiceProvider),
    ref.watch(authSessionProvider.notifier),
  ),
);

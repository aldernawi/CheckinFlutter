import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/core/models/employee_dto.dart';
import 'package:checkin_flutter/core/models/login_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_routes.dart';
import 'package:checkin_flutter/core/network/auth_session_manager.dart';
import 'package:checkin_flutter/core/storage/secure_storage_service.dart';
import 'package:checkin_flutter/core/storage/employee_cache.dart';
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
      ApiRoutes.login,
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
      final roleSet = determineRoleSet(data.employee);
      await _sessionNotifier.saveSession(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
        roleSet: roleSet,
      );
      await _storage.write(
        StorageKeys.employeeData,
        encodeEmployeeCache(data.employee),
      );
      await _apiClient.post<bool>(
        ApiRoutes.registerDevice,
        data: RegisterDeviceRequest(
          deviceId: deviceId,
          deviceName: deviceName,
          deviceType: deviceType,
          operatingSystem: deviceType,
        ).toJson(),
        converter: (value) => value is bool ? value : true,
      );
      return (success: true, error: null);
    }

    return (
      success: false,
      error: response.error?.message ?? 'فشل تسجيل الدخول',
    );
  }

  Future<void> logout() async {
    await _sessionNotifier.logout();
  }

  Future<({bool success, String? error})> forgotPassword(String _) async {
    return (
      success: false,
      error: 'خدمة استعادة كلمة المرور غير متاحة حالياً.',
    );
  }

  Future<({bool success, String? error})> selfRegister({
    required String fullName,
    required String phone,
    required String password,
    required String branchId,
    String? email,
  }) async {
    final response = await _apiClient.post<bool>(
      ApiRoutes.selfRegister,
      data: {
        'fullName': fullName.trim(),
        'phone': phone.trim(),
        'password': password,
        'branchId': branchId,
        if (email != null && email.isNotEmpty) 'email': email.trim(),
      },
      converter: (value) => value is bool ? value : true,
    );
    if (response.success) {
      return (success: true, error: null);
    }
    return (
      success: false,
      error: response.error?.message ?? 'فشل إنشاء الحساب',
    );
  }

  Future<List<BranchOption>> getRegistrationBranches() async {
    final response = await _apiClient.get<List<BranchOption>>(
      ApiRoutes.branchesLookup,
      converter: (value) => value is List
          ? value
                .whereType<Map<String, dynamic>>()
                .map(BranchOption.fromJson)
                .toList()
          : null,
    );
    return response.data ?? const [];
  }

  static AppUserRoleSet determineRoleSet(EmployeeDto employee) {
    final managerRoles = {
      'teamlead',
      'manager',
      'branchmanager',
      'hr',
      'hrmanager',
      'admin',
    };
    final fieldTypes = {2, 3, 4};
    final fieldRoles = {'fieldrep', 'salesrep', 'deliveryrep'};
    final normalizedRoles = employee.roles
        .map((role) => role.trim().toLowerCase())
        .toSet();

    if (employee.employeeType != null &&
        fieldTypes.contains(employee.employeeType)) {
      return AppUserRoleSet.fieldRep;
    }

    if (normalizedRoles.any(fieldRoles.contains)) {
      return AppUserRoleSet.fieldRep;
    }

    if (normalizedRoles.any(managerRoles.contains)) {
      return AppUserRoleSet.manager;
    }

    return AppUserRoleSet.employee;
  }
}

class BranchOption {
  const BranchOption({required this.id, required this.name, this.nameAr});

  final String id;
  final String name;
  final String? nameAr;

  String get displayName => nameAr?.isNotEmpty == true ? nameAr! : name;

  factory BranchOption.fromJson(Map<String, dynamic> json) => BranchOption(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    nameAr: json['nameAr'] as String?,
  );
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(secureStorageServiceProvider),
    ref.watch(authSessionProvider.notifier),
  ),
);

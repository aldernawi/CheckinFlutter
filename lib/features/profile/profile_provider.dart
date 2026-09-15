import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/core/models/employee_dto.dart';
import 'package:checkin_flutter/core/storage/employee_cache.dart';
import 'package:checkin_flutter/core/storage/secure_storage_service.dart';
import 'package:checkin_flutter/features/profile/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProfileLoadStatus { idle, loading, success, error }

class ProfileState {
  const ProfileState({
    this.status = ProfileLoadStatus.idle,
    this.employee,
    this.isSaving = false,
    this.errorMessage,
  });

  final ProfileLoadStatus status;
  final EmployeeDto? employee;
  final bool isSaving;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileLoadStatus? status,
    EmployeeDto? employee,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      employee: employee ?? this.employee,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this._repo, this._storage) : super(const ProfileState());

  final ProfileRepository _repo;
  final SecureStorageService _storage;

  Future<void> loadProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && state.employee != null) return;

    final cached = decodeEmployeeCache(
      await _storage.read(StorageKeys.employeeData),
    );
    state = state.copyWith(
      status: cached == null
          ? ProfileLoadStatus.loading
          : ProfileLoadStatus.success,
      employee: cached,
      clearError: true,
    );

    final response = await _repo.getProfile();
    if (response.success && response.data != null) {
      final employee = response.data!;
      await _storage.write(
        StorageKeys.employeeData,
        encodeEmployeeCache(employee),
      );
      state = state.copyWith(
        status: ProfileLoadStatus.success,
        employee: employee,
        clearError: true,
      );
      return;
    }

    state = state.copyWith(
      status: cached == null
          ? ProfileLoadStatus.error
          : ProfileLoadStatus.success,
      errorMessage: response.error?.message ?? 'فشل تحميل الملف الشخصي',
    );
  }

  Future<({bool success, String? error})> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    final response = await _repo.changePassword(
      ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
    state = state.copyWith(isSaving: false);
    if (response.success) {
      return (success: true, error: null);
    }
    return (
      success: false,
      error: response.error?.message ?? 'فشل تغيير كلمة المرور',
    );
  }

  Future<({bool success, String? error})> updateProfile(
    UpdateProfileRequest request,
  ) async {
    state = state.copyWith(isSaving: true, clearError: true);
    final response = await _repo.updateProfile(request);
    state = state.copyWith(isSaving: false);
    if (response.success) {
      await loadProfile(forceRefresh: true);
      return (success: true, error: null);
    }
    return (
      success: false,
      error: response.error?.message ?? 'فشل تحديث الملف الشخصي',
    );
  }

  Future<({bool success, String? error})> deleteAccount({
    required String password,
    required AccountDeletionReason reason,
    String? feedback,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    final response = await _repo.deleteAccount(
      DeleteAccountRequest(
        password: password,
        reason: reason,
        feedback: feedback,
      ),
    );
    state = state.copyWith(isSaving: false);
    if (response.success) {
      return (success: true, error: null);
    }
    return (success: false, error: response.error?.message ?? 'فشل حذف الحساب');
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(
    ref.watch(profileRepositoryProvider),
    ref.watch(secureStorageServiceProvider),
  ),
);

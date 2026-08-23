import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/features/profile/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends StateNotifier<bool> {
  ProfileNotifier(this._repo) : super(false);

  final ProfileRepository _repo;

  Future<({bool success, String? error})> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = true;
    final response = await _repo.changePassword(ChangePasswordRequest(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    ));
    state = false;
    if (response.success) {
      return (success: true, error: null);
    }
    return (success: false, error: response.error?.message ?? 'فشل تغيير كلمة المرور');
  }

  Future<({bool success, String? error})> updateProfile(UpdateProfileRequest request) async {
    state = true;
    final response = await _repo.updateProfile(request);
    state = false;
    if (response.success) {
      return (success: true, error: null);
    }
    return (success: false, error: response.error?.message ?? 'فشل تحديث الملف الشخصي');
  }

  Future<({bool success, String? error})> deleteAccount({
    required String password,
    required AccountDeletionReason reason,
    String? feedback,
  }) async {
    state = true;
    final response = await _repo.deleteAccount(DeleteAccountRequest(
      password: password,
      reason: reason,
      feedback: feedback,
    ));
    state = false;
    if (response.success) {
      return (success: true, error: null);
    }
    return (success: false, error: response.error?.message ?? 'فشل حذف الحساب');
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, bool>(
  (ref) => ProfileNotifier(ref.watch(profileRepositoryProvider)),
);

import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:checkin_flutter/core/network/api_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileRepository {
  ProfileRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<bool>> changePassword(ChangePasswordRequest request) {
    return _apiClient.post<bool>(
      ApiRoutes.changePassword,
      data: request.toJson(),
      converter: (value) => value is bool ? value : true,
    );
  }

  Future<ApiResponse<bool>> updateProfile(UpdateProfileRequest request) {
    return _apiClient.put<bool>(
      ApiRoutes.myProfile,
      data: request.toJson(),
      converter: (value) => value is bool ? value : true,
    );
  }

  Future<ApiResponse<bool>> deleteAccount(DeleteAccountRequest request) {
    return _apiClient.delete<bool>(
      ApiRoutes.deleteMyAccount,
      data: request.toJson(),
      converter: (value) => value is bool ? value : true,
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(apiClientProvider)),
);

import 'package:checkin_flutter/core/models/device_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicesRepository {
  DevicesRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<DevicesListResponse>> getDevices() {
    return _apiClient.get<DevicesListResponse>(
      'api/v1/devices',
      converter: (value) => value is Map<String, dynamic>
          ? DevicesListResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<bool>> revokeDevice(String deviceId) {
    return _apiClient.delete<bool>(
      'api/v1/devices/$deviceId',
      converter: (value) => value is bool ? value : true,
    );
  }
}

final devicesRepositoryProvider = Provider<DevicesRepository>(
  (ref) => DevicesRepository(ref.watch(apiClientProvider)),
);

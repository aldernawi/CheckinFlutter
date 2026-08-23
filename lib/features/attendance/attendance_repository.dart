import 'package:checkin_flutter/core/models/attendance_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceRepository {
  AttendanceRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<AttendanceStatusResponse>> getStatus() {
    return _apiClient.get<AttendanceStatusResponse>(
      'api/v1/attendance/status',
      converter: (value) => value is Map<String, dynamic>
          ? AttendanceStatusResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<CheckinResponse>> checkin(CheckinRequest request) {
    return _apiClient.post<CheckinResponse>(
      'api/v1/attendance/checkin',
      data: request.toJson(),
      converter: (value) =>
          value is Map<String, dynamic> ? CheckinResponse.fromJson(value) : null,
    );
  }

  Future<ApiResponse<CheckoutResponse>> checkout(CheckinRequest request) {
    return _apiClient.post<CheckoutResponse>(
      'api/v1/attendance/checkout',
      data: request.toJson(),
      converter: (value) =>
          value is Map<String, dynamic> ? CheckoutResponse.fromJson(value) : null,
    );
  }

  Future<ApiResponse<NearbyLocationsResponse>> getNearbyLocations(
    double lat,
    double lng,
  ) {
    return _apiClient.get<NearbyLocationsResponse>(
      'api/v1/locations/nearby',
      queryParameters: {
        'latitude': lat.toString(),
        'longitude': lng.toString(),
      },
      converter: (value) => value is Map<String, dynamic>
          ? NearbyLocationsResponse.fromJson(value)
          : null,
    );
  }
}

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => AttendanceRepository(ref.watch(apiClientProvider)),
);

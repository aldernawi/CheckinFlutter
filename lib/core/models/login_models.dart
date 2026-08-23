import 'package:checkin_flutter/core/models/employee_dto.dart';

class LoginRequest {
  LoginRequest({
    required this.phone,
    required this.password,
    required this.deviceId,
    this.deviceName,
    this.deviceType = 'Android',
  });

  final String phone;
  final String password;
  final String deviceId;
  final String? deviceName;
  final String deviceType;

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'deviceType': deviceType,
      };
}

class LoginResponse {
  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.employee,
  });

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final EmployeeDto employee;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresIn: json['expiresIn'] as int? ?? 0,
      employee: json['employee'] is Map<String, dynamic>
          ? EmployeeDto.fromJson(json['employee'] as Map<String, dynamic>)
          : EmployeeDto(
              id: '',
              employeeNumber: '',
              fullName: '',
              phone: '',
            ),
    );
  }
}

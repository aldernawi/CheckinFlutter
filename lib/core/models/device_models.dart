class DeviceDto {
  DeviceDto({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    this.osVersion,
    this.appVersion,
    required this.registeredAt,
    this.lastUsedAt,
    this.isCurrentDevice = false,
    this.isActive = false,
  });

  final String id;
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String? osVersion;
  final String? appVersion;
  final DateTime registeredAt;
  final DateTime? lastUsedAt;
  final bool isCurrentDevice;
  final bool isActive;

  factory DeviceDto.fromJson(Map<String, dynamic> json) {
    return DeviceDto(
      id: json['id'] as String? ?? '',
      deviceId: json['deviceId'] as String? ?? '',
      deviceName: json['deviceName'] as String? ?? '',
      deviceType: json['deviceType'] as String? ?? '',
      osVersion: json['osVersion'] as String?,
      appVersion: json['appVersion'] as String?,
      registeredAt: json['registeredAt'] != null
          ? DateTime.tryParse(json['registeredAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.tryParse(json['lastUsedAt'] as String)
          : null,
      isCurrentDevice: json['isCurrentDevice'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

class DevicesListResponse {
  DevicesListResponse({required this.devices, required this.maxDevices});

  final List<DeviceDto> devices;
  final int maxDevices;

  int get registeredCount => devices.length;

  factory DevicesListResponse.fromJson(Map<String, dynamic> json) {
    return DevicesListResponse(
      devices: (json['devices'] as List?)
              ?.map((e) => DeviceDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      maxDevices: json['maxDevices'] as int? ?? 2,
    );
  }
}

class RegisterDeviceRequest {
  RegisterDeviceRequest({
    required this.deviceId,
    this.deviceName,
    this.deviceType,
    this.operatingSystem,
    this.osVersion,
    this.appVersion,
    this.fcmToken,
  });

  final String deviceId;
  final String? deviceName;
  final String? deviceType;
  final String? operatingSystem;
  final String? osVersion;
  final String? appVersion;
  final String? fcmToken;

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'deviceName': deviceName,
        'deviceType': deviceType,
        'operatingSystem': operatingSystem,
        'osVersion': osVersion,
        'appVersion': appVersion,
        'fcmToken': fcmToken,
      };
}

class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  Map<String, dynamic> toJson() => {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
}

enum AccountDeletionReason { resignation, noLongerNeeded, privacyConcerns, other }

class DeleteAccountRequest {
  DeleteAccountRequest({
    required this.password,
    required this.reason,
    this.feedback,
  });

  final String password;
  final AccountDeletionReason reason;
  final String? feedback;

  Map<String, dynamic> toJson() => {
        'password': password,
        'reason': reason.index + 1,
        'feedback': feedback,
      };
}

class UpdateProfileRequest {
  UpdateProfileRequest({
    this.fullName,
    this.fullNameAr,
    this.phone,
    this.email,
    this.profilePicture,
  });

  final String? fullName;
  final String? fullNameAr;
  final String? phone;
  final String? email;
  final String? profilePicture;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'fullNameAr': fullNameAr,
        'phone': phone,
        'email': email,
        'profilePicture': profilePicture,
      };
}

class CalendarDayDto {
  CalendarDayDto({
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.workedMinutes = 0,
    this.lateMinutes = 0,
  });

  final DateTime date;
  final int status;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final int workedMinutes;
  final int lateMinutes;

  factory CalendarDayDto.fromJson(Map<String, dynamic> json) {
    return CalendarDayDto(
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as int? ?? 0,
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'] as String)
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.tryParse(json['checkOutTime'] as String)
          : null,
      workedMinutes: json['workedMinutes'] as int? ?? 0,
      lateMinutes: json['lateMinutes'] as int? ?? 0,
    );
  }
}

class CalendarResponse {
  CalendarResponse({required this.days, required this.month, required this.year});

  final List<CalendarDayDto> days;
  final int month;
  final int year;

  factory CalendarResponse.fromJson(Map<String, dynamic> json) {
    return CalendarResponse(
      days: (json['days'] as List?)
              ?.map((e) => CalendarDayDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      month: json['month'] as int? ?? DateTime.now().month,
      year: json['year'] as int? ?? DateTime.now().year,
    );
  }
}

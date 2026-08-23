class AttendanceStatusResponse {
  AttendanceStatusResponse({
    required this.isCheckedIn,
    required this.isCheckedOut,
    this.checkInTime,
    this.checkOutTime,
    required this.canCheckIn,
    required this.canCheckOut,
    required this.isWorkDay,
    this.shift,
  });

  final bool isCheckedIn;
  final bool isCheckedOut;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final bool canCheckIn;
  final bool canCheckOut;
  final bool isWorkDay;
  final AttendanceShiftInfo? shift;

  factory AttendanceStatusResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceStatusResponse(
      isCheckedIn: json['isCheckedIn'] as bool? ?? false,
      isCheckedOut: json['isCheckedOut'] as bool? ?? false,
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'] as String)
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.tryParse(json['checkOutTime'] as String)
          : null,
      canCheckIn: json['canCheckIn'] as bool? ?? false,
      canCheckOut: json['canCheckOut'] as bool? ?? false,
      isWorkDay: json['isWorkDay'] as bool? ?? true,
      shift: json['shift'] is Map<String, dynamic>
          ? AttendanceShiftInfo.fromJson(json['shift'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AttendanceShiftInfo {
  AttendanceShiftInfo({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.gracePeriodMinutes,
  });

  final String name;
  final String startTime;
  final String endTime;
  final int gracePeriodMinutes;

  factory AttendanceShiftInfo.fromJson(Map<String, dynamic> json) {
    return AttendanceShiftInfo(
      name: json['name'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      gracePeriodMinutes: json['gracePeriodMinutes'] as int? ?? 0,
    );
  }
}

class CheckinRequest {
  CheckinRequest({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.deviceId,
    this.notes,
    this.isOffline = false,
    this.localTimestamp,
    this.isRootedDevice = false,
    this.isMockLocation = false,
  });

  final double latitude;
  final double longitude;
  final double accuracy;
  final String deviceId;
  final String? notes;
  final bool isOffline;
  final DateTime? localTimestamp;
  final bool isRootedDevice;
  final bool isMockLocation;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'deviceId': deviceId,
        'notes': notes,
        'isOffline': isOffline,
        'localTimestamp': localTimestamp?.toIso8601String(),
        'isRootedDevice': isRootedDevice,
        'isMockLocation': isMockLocation,
      };
}

class CheckinResponse {
  CheckinResponse({
    required this.id,
    required this.date,
    required this.checkInTime,
    required this.status,
    required this.lateMinutes,
    this.location,
    this.flags = const [],
  });

  final String id;
  final String date;
  final DateTime checkInTime;
  final int status;
  final int lateMinutes;
  final LocationDto? location;
  final List<String> flags;

  factory CheckinResponse.fromJson(Map<String, dynamic> json) {
    return CheckinResponse(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      checkInTime: DateTime.tryParse(json['checkInTime'] as String? ?? '') ?? DateTime.now(),
      status: json['status'] as int? ?? 0,
      lateMinutes: json['lateMinutes'] as int? ?? 0,
      location: json['location'] is Map<String, dynamic>
          ? LocationDto.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      flags: (json['flags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

class CheckoutResponse {
  CheckoutResponse({
    required this.id,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.workedMinutes,
    required this.overtimeMinutes,
    required this.earlyDepartureMinutes,
    required this.status,
    this.location,
    this.flags = const [],
  });

  final String id;
  final String date;
  final DateTime checkInTime;
  final DateTime checkOutTime;
  final int workedMinutes;
  final int overtimeMinutes;
  final int earlyDepartureMinutes;
  final int status;
  final LocationDto? location;
  final List<String> flags;

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      checkInTime: DateTime.tryParse(json['checkInTime'] as String? ?? '') ?? DateTime.now(),
      checkOutTime: DateTime.tryParse(json['checkOutTime'] as String? ?? '') ?? DateTime.now(),
      workedMinutes: json['workedMinutes'] as int? ?? 0,
      overtimeMinutes: json['overtimeMinutes'] as int? ?? 0,
      earlyDepartureMinutes: json['earlyDepartureMinutes'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
      location: json['location'] is Map<String, dynamic>
          ? LocationDto.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      flags: (json['flags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

class LocationDto {
  LocationDto({required this.id, required this.name, this.nameAr});

  final String id;
  final String name;
  final String? nameAr;

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
    );
  }
}

class NearbyLocationDto {
  NearbyLocationDto({
    required this.id,
    required this.name,
    this.nameAr,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.radiusInMeters,
    required this.distanceInMeters,
    required this.isWithinRange,
  });

  final String id;
  final String name;
  final String? nameAr;
  final int type;
  final double latitude;
  final double longitude;
  final int radiusInMeters;
  final double distanceInMeters;
  final bool isWithinRange;

  factory NearbyLocationDto.fromJson(Map<String, dynamic> json) {
    return NearbyLocationDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
      type: (json['type'] as num?)?.toInt() ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      radiusInMeters: (json['radiusInMeters'] as num?)?.toInt() ?? 0,
      distanceInMeters: (json['distanceInMeters'] as num?)?.toDouble() ?? 0,
      isWithinRange: json['isWithinRange'] as bool? ?? false,
    );
  }
}

class NearbyLocationsResponse {
  NearbyLocationsResponse({required this.items});

  final List<NearbyLocationDto> items;

  factory NearbyLocationsResponse.fromJson(Map<String, dynamic> json) {
    return NearbyLocationsResponse(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => NearbyLocationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

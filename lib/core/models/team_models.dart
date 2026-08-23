enum AttendanceStatus { early, present, late, veryLate, absent, holiday, leave }

class TeamMemberAttendanceDto {
  TeamMemberAttendanceDto({
    required this.employeeId,
    required this.employeeNumber,
    required this.fullName,
    this.fullNameAr,
    this.profilePicture,
    this.status,
    this.statusName = '',
    this.checkInTime,
    this.checkOutTime,
    this.lateMinutes = 0,
    this.workedMinutes = 0,
    this.checkInLocation,
  });

  final String employeeId;
  final String employeeNumber;
  final String fullName;
  final String? fullNameAr;
  final String? profilePicture;
  final AttendanceStatus? status;
  final String statusName;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final int lateMinutes;
  final int workedMinutes;
  final String? checkInLocation;

  String get displayName => fullNameAr ?? fullName;

  factory TeamMemberAttendanceDto.fromJson(Map<String, dynamic> json) {
    return TeamMemberAttendanceDto(
      employeeId: json['employeeId'] as String? ?? '',
      employeeNumber: json['employeeNumber'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      fullNameAr: json['fullNameAr'] as String?,
      profilePicture: json['profilePicture'] as String?,
      status: json['status'] != null
          ? AttendanceStatus.values.firstWhere(
              (e) => e.index == (json['status'] as int),
              orElse: () => AttendanceStatus.absent,
            )
          : null,
      statusName: json['statusName'] as String? ?? '',
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'] as String)
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.tryParse(json['checkOutTime'] as String)
          : null,
      lateMinutes: json['lateMinutes'] as int? ?? 0,
      workedMinutes: json['workedMinutes'] as int? ?? 0,
      checkInLocation: json['checkInLocation'] as String?,
    );
  }
}

class TeamAttendanceSummary {
  TeamAttendanceSummary({
    this.totalMembers = 0,
    this.present = 0,
    this.late = 0,
    this.absent = 0,
    this.onLeave = 0,
    this.attendanceRate = 0,
  });

  final int totalMembers;
  final int present;
  final int late;
  final int absent;
  final int onLeave;
  final double attendanceRate;

  factory TeamAttendanceSummary.fromJson(Map<String, dynamic> json) {
    return TeamAttendanceSummary(
      totalMembers: json['totalMembers'] as int? ?? 0,
      present: json['present'] as int? ?? 0,
      late: json['late'] as int? ?? 0,
      absent: json['absent'] as int? ?? 0,
      onLeave: json['onLeave'] as int? ?? 0,
      attendanceRate: (json['attendanceRate'] as num?)?.toDouble() ?? 0,
    );
  }
}

class TeamAttendanceResponse {
  TeamAttendanceResponse({
    required this.date,
    required this.summary,
    required this.items,
    required this.totalCount,
  });

  final DateTime date;
  final TeamAttendanceSummary summary;
  final List<TeamMemberAttendanceDto> items;
  final int totalCount;

  factory TeamAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return TeamAttendanceResponse(
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      summary: json['summary'] != null
          ? TeamAttendanceSummary.fromJson(json['summary'] as Map<String, dynamic>)
          : TeamAttendanceSummary(),
      items: (json['items'] as List?)
              ?.map((e) =>
                  TeamMemberAttendanceDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

class PendingRequestDto {
  PendingRequestDto({
    required this.id,
    required this.requestNumber,
    required this.type,
    required this.typeName,
    this.typeNameAr,
    required this.employeeId,
    required this.employeeName,
    this.employeeNameAr,
    this.employeePhoto,
    required this.effectiveDate,
    this.endDate,
    required this.reason,
    required this.createdAt,
    this.daysCount = 1,
  });

  final String id;
  final String requestNumber;
  final int type;
  final String typeName;
  final String? typeNameAr;
  final String employeeId;
  final String employeeName;
  final String? employeeNameAr;
  final String? employeePhoto;
  final DateTime effectiveDate;
  final DateTime? endDate;
  final String reason;
  final DateTime createdAt;
  final int daysCount;

  String get employeeDisplayName => employeeNameAr ?? employeeName;

  factory PendingRequestDto.fromJson(Map<String, dynamic> json) {
    return PendingRequestDto(
      id: json['id'] as String? ?? '',
      requestNumber: json['requestNumber'] as String? ?? '',
      type: json['type'] as int? ?? 0,
      typeName: json['typeName'] as String? ?? '',
      typeNameAr: json['typeNameAr'] as String?,
      employeeId: json['employeeId'] as String? ?? '',
      employeeName: json['employeeName'] as String? ?? '',
      employeeNameAr: json['employeeNameAr'] as String?,
      employeePhoto: json['employeePhoto'] as String?,
      effectiveDate: json['effectiveDate'] != null
          ? DateTime.tryParse(json['effectiveDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      reason: json['reason'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      daysCount: json['daysCount'] as int? ?? 1,
    );
  }
}

class PendingRequestsResponse {
  PendingRequestsResponse({required this.items, required this.totalCount});

  final List<PendingRequestDto> items;
  final int totalCount;

  factory PendingRequestsResponse.fromJson(Map<String, dynamic> json) {
    return PendingRequestsResponse(
      items: (json['items'] as List?)
              ?.map((e) => PendingRequestDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

class ApproveRejectRequest {
  ApproveRejectRequest({this.notes, this.rejectionReason});

  final String? notes;
  final String? rejectionReason;

  Map<String, dynamic> toJson() => {
        'notes': notes,
        'rejectionReason': rejectionReason,
      };
}

import 'package:checkin_flutter/core/models/attendance_models.dart';

enum OfflineReviewStatus { notApplicable, pending, approved, rejected }

class AttendanceRecordDto {
  AttendanceRecordDto({
    required this.id,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.status = 0,
    this.workedMinutes = 0,
    this.lateMinutes = 0,
    this.overtimeMinutes = 0,
    this.earlyDepartureMinutes = 0,
    this.checkInLocation,
    this.checkOutLocation,
    this.flags = const [],
    this.notes,
    this.isOfflineRecord = false,
    this.offlineReviewStatus = OfflineReviewStatus.notApplicable,
    this.reviewNotes,
    this.reviewedAt,
  });

  final String id;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final int status;
  final int workedMinutes;
  final int lateMinutes;
  final int overtimeMinutes;
  final int earlyDepartureMinutes;
  final LocationDto? checkInLocation;
  final LocationDto? checkOutLocation;
  final List<String> flags;
  final String? notes;
  final bool isOfflineRecord;
  final OfflineReviewStatus offlineReviewStatus;
  final String? reviewNotes;
  final DateTime? reviewedAt;

  String? get checkInLocationText => checkInLocation?.name;

  bool get showReviewStatus =>
      isOfflineRecord &&
      offlineReviewStatus != OfflineReviewStatus.notApplicable;

  String? get offlineReviewStatusText {
    switch (offlineReviewStatus) {
      case OfflineReviewStatus.pending:
        return 'في انتظار المراجعة';
      case OfflineReviewStatus.approved:
        return 'تمت الموافقة';
      case OfflineReviewStatus.rejected:
        return 'مرفوض';
      case OfflineReviewStatus.notApplicable:
        return null;
    }
  }

  factory AttendanceRecordDto.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordDto(
      id: json['id'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'] as String)
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.tryParse(json['checkOutTime'] as String)
          : null,
      status: json['status'] as int? ?? 0,
      workedMinutes: json['workedMinutes'] as int? ?? 0,
      lateMinutes: json['lateMinutes'] as int? ?? 0,
      overtimeMinutes: json['overtimeMinutes'] as int? ?? 0,
      earlyDepartureMinutes: json['earlyDepartureMinutes'] as int? ?? 0,
      checkInLocation: json['checkInLocation'] != null
          ? LocationDto.fromJson(json['checkInLocation'] as Map<String, dynamic>)
          : null,
      checkOutLocation: json['checkOutLocation'] != null
          ? LocationDto.fromJson(json['checkOutLocation'] as Map<String, dynamic>)
          : null,
      flags: (json['flags'] as List?)?.map((e) => e as String).toList() ?? [],
      notes: json['notes'] as String?,
      isOfflineRecord: json['isOfflineRecord'] as bool? ?? false,
      offlineReviewStatus: OfflineReviewStatus
          .values[json['offlineReviewStatus'] as int? ?? 0],
      reviewNotes: json['reviewNotes'] as String?,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.tryParse(json['reviewedAt'] as String)
          : null,
    );
  }
}

class AttendanceHistoryResponse {
  AttendanceHistoryResponse({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  final List<AttendanceRecordDto> items;
  final int totalCount;
  final int page;
  final int pageSize;

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryResponse(
      items: (json['items'] as List?)
              ?.map((e) =>
                  AttendanceRecordDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
    );
  }
}

enum RequestType {
  leave(1),
  attendanceCorrection(2),
  remoteWork(3),
  shiftChange(4),
  locationAdd(5),
  exceptionalCheckin(6);

  const RequestType(this.value);
  final int value;

  static RequestType fromValue(int v) =>
      RequestType.values.firstWhere((e) => e.value == v, orElse: () => RequestType.leave);
}

enum RequestStatus {
  pending(1),
  approved(2),
  rejected(3),
  cancelled(4);

  const RequestStatus(this.value);
  final int value;

  static RequestStatus fromValue(int v) =>
      RequestStatus.values.firstWhere((e) => e.value == v, orElse: () => RequestStatus.pending);
}

class RequestDto {
  RequestDto({
    required this.id,
    required this.requestNumber,
    required this.type,
    required this.typeName,
    this.typeNameAr,
    required this.status,
    required this.statusName,
    required this.effectiveDate,
    this.endDate,
    required this.reason,
    this.rejectionReason,
    this.approverName,
    required this.createdAt,
    this.processedAt,
  });

  final String id;
  final String requestNumber;
  final RequestType type;
  final String typeName;
  final String? typeNameAr;
  final RequestStatus status;
  final String statusName;
  final String effectiveDate;
  final String? endDate;
  final String reason;
  final String? rejectionReason;
  final String? approverName;
  final DateTime createdAt;
  final DateTime? processedAt;

  factory RequestDto.fromJson(Map<String, dynamic> json) {
    return RequestDto(
      id: json['id'] as String? ?? '',
      requestNumber: json['requestNumber'] as String? ?? '',
      type: RequestType.fromValue((json['type'] as num?)?.toInt() ?? 1),
      typeName: json['typeName'] as String? ?? '',
      typeNameAr: json['typeNameAr'] as String?,
      status: RequestStatus.fromValue((json['status'] as num?)?.toInt() ?? 1),
      statusName: json['statusName'] as String? ?? '',
      effectiveDate: json['effectiveDate'] as String? ?? '',
      endDate: json['endDate'] as String?,
      reason: json['reason'] as String? ?? '',
      rejectionReason: json['rejectionReason'] as String?,
      approverName: json['approverName'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      processedAt: json['processedAt'] != null
          ? DateTime.tryParse(json['processedAt'] as String)
          : null,
    );
  }
}

class CreateRequestRequest {
  CreateRequestRequest({
    required this.type,
    required this.effectiveDate,
    this.endDate,
    required this.reason,
    this.details,
  });

  final RequestType type;
  final String effectiveDate;
  final String? endDate;
  final String reason;
  final String? details;

  Map<String, dynamic> toJson() => {
        'type': type.value,
        'effectiveDate': effectiveDate,
        'endDate': endDate,
        'reason': reason,
        'details': details,
      };
}

class RequestsListResponse {
  RequestsListResponse({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  final List<RequestDto> items;
  final int totalCount;
  final int page;
  final int pageSize;

  factory RequestsListResponse.fromJson(Map<String, dynamic> json) {
    return RequestsListResponse(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => RequestDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
    );
  }
}

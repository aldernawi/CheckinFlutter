class RecordVisitRequest {
  RecordVisitRequest({
    required this.storeId,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.notes,
    this.photos,
    this.deviceId,
    this.isOffline = false,
    this.localTimestamp,
    this.isMockLocation = false,
    this.isRootedDevice = false,
  });

  final String storeId;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final String? notes;
  final List<String>? photos;
  final String? deviceId;
  final bool isOffline;
  final DateTime? localTimestamp;
  final bool isMockLocation;
  final bool isRootedDevice;

  Map<String, dynamic> toJson() => {
        'storeId': storeId,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'notes': notes,
        'photos': photos,
        'deviceId': deviceId,
        'isOffline': isOffline,
        'localTimestamp': localTimestamp?.toIso8601String(),
        'isMockLocation': isMockLocation,
        'isRootedDevice': isRootedDevice,
      };
}

class RecordVisitResponse {
  RecordVisitResponse({
    required this.id,
    required this.visitNumber,
    required this.checkInTime,
    required this.distanceFromStore,
    required this.status,
    required this.isFirstVisitOfDay,
    this.flags = const [],
    this.attendanceId,
  });

  final String id;
  final String visitNumber;
  final DateTime checkInTime;
  final int distanceFromStore;
  final int status;
  final bool isFirstVisitOfDay;
  final List<String> flags;
  final String? attendanceId;

  factory RecordVisitResponse.fromJson(Map<String, dynamic> json) {
    return RecordVisitResponse(
      id: json['id'] as String? ?? '',
      visitNumber: json['visitNumber'] as String? ?? '',
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'] as String) ?? DateTime.now()
          : DateTime.now(),
      distanceFromStore: json['distanceFromStore'] as int? ?? 0,
      status: json['status'] as int? ?? 1,
      isFirstVisitOfDay: json['isFirstVisitOfDay'] as bool? ?? false,
      flags: (json['flags'] as List?)?.map((e) => e as String).toList() ?? [],
      attendanceId: json['attendanceId'] as String?,
    );
  }
}

class StoreBasicDto {
  StoreBasicDto({
    required this.id,
    required this.name,
    this.nameAr,
    this.address,
  });

  final String id;
  final String name;
  final String? nameAr;
  final String? address;

  String get displayName => nameAr ?? name;

  factory StoreBasicDto.fromJson(Map<String, dynamic> json) {
    return StoreBasicDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
      address: json['address'] as String?,
    );
  }
}

class FieldVisitDto {
  FieldVisitDto({
    required this.id,
    required this.visitNumber,
    required this.visitDate,
    required this.checkInTime,
    this.checkOutTime,
    this.durationMinutes,
    required this.distanceFromStore,
    required this.status,
    this.notes,
    this.photos = const [],
    this.flags = const [],
    this.isFirstVisitOfDay = false,
    this.isLastVisitOfDay = false,
    required this.store,
  });

  final String id;
  final String visitNumber;
  final DateTime visitDate;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final int? durationMinutes;
  final int distanceFromStore;
  final int status;
  final String? notes;
  final List<String> photos;
  final List<String> flags;
  final bool isFirstVisitOfDay;
  final bool isLastVisitOfDay;
  final StoreBasicDto store;

  factory FieldVisitDto.fromJson(Map<String, dynamic> json) {
    return FieldVisitDto(
      id: json['id'] as String? ?? '',
      visitNumber: json['visitNumber'] as String? ?? '',
      visitDate: json['visitDate'] != null
          ? DateTime.tryParse(json['visitDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'] as String) ?? DateTime.now()
          : DateTime.now(),
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.tryParse(json['checkOutTime'] as String)
          : null,
      durationMinutes: json['durationMinutes'] as int?,
      distanceFromStore: json['distanceFromStore'] as int? ?? 0,
      status: json['status'] as int? ?? 1,
      notes: json['notes'] as String?,
      photos: (json['photos'] as List?)?.map((e) => e as String).toList() ?? [],
      flags: (json['flags'] as List?)?.map((e) => e as String).toList() ?? [],
      isFirstVisitOfDay: json['isFirstVisitOfDay'] as bool? ?? false,
      isLastVisitOfDay: json['isLastVisitOfDay'] as bool? ?? false,
      store: json['store'] != null
          ? StoreBasicDto.fromJson(json['store'] as Map<String, dynamic>)
          : StoreBasicDto(id: '', name: ''),
    );
  }
}

class FieldVisitListItemDto {
  FieldVisitListItemDto({
    required this.id,
    required this.storeId,
    required this.visitNumber,
    required this.visitDate,
    required this.checkInTime,
    this.checkOutTime,
    this.durationMinutes,
    required this.distanceFromStore,
    required this.status,
    required this.storeName,
    this.storeNameAr,
    this.hasPhotos = false,
    this.isFirstVisitOfDay = false,
  });

  final String id;
  final String storeId;
  final String visitNumber;
  final DateTime visitDate;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final int? durationMinutes;
  final int distanceFromStore;
  final int status;
  final String storeName;
  final String? storeNameAr;
  final bool hasPhotos;
  final bool isFirstVisitOfDay;

  String get storeDisplayName => storeNameAr ?? storeName;

  factory FieldVisitListItemDto.fromJson(Map<String, dynamic> json) {
    return FieldVisitListItemDto(
      id: json['id'] as String? ?? '',
      storeId: json['storeId'] as String? ?? '',
      visitNumber: json['visitNumber'] as String? ?? '',
      visitDate: json['visitDate'] != null
          ? DateTime.tryParse(json['visitDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      checkInTime: json['checkInTime'] != null
          ? DateTime.tryParse(json['checkInTime'] as String) ?? DateTime.now()
          : DateTime.now(),
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.tryParse(json['checkOutTime'] as String)
          : null,
      durationMinutes: json['durationMinutes'] as int?,
      distanceFromStore: json['distanceFromStore'] as int? ?? 0,
      status: json['status'] as int? ?? 1,
      storeName: json['storeName'] as String? ?? '',
      storeNameAr: json['storeNameAr'] as String?,
      hasPhotos: json['hasPhotos'] as bool? ?? false,
      isFirstVisitOfDay: json['isFirstVisitOfDay'] as bool? ?? false,
    );
  }
}

class TodayVisitsSummaryDto {
  TodayVisitsSummaryDto({
    this.totalVisits = 0,
    this.minRequiredVisits = 0,
    this.remainingVisits = 0,
    this.metMinimum = false,
    this.firstVisitTime,
    this.lastVisitTime,
    this.totalDurationMinutes = 0,
    this.visits = const [],
  });

  final int totalVisits;
  final int minRequiredVisits;
  final int remainingVisits;
  final bool metMinimum;
  final DateTime? firstVisitTime;
  final DateTime? lastVisitTime;
  final int totalDurationMinutes;
  final List<FieldVisitListItemDto> visits;

  factory TodayVisitsSummaryDto.fromJson(Map<String, dynamic> json) {
    return TodayVisitsSummaryDto(
      totalVisits: json['totalVisits'] as int? ?? 0,
      minRequiredVisits: json['minRequiredVisits'] as int? ?? 0,
      remainingVisits: json['remainingVisits'] as int? ?? 0,
      metMinimum: json['metMinimum'] as bool? ?? false,
      firstVisitTime: json['firstVisitTime'] != null
          ? DateTime.tryParse(json['firstVisitTime'] as String)
          : null,
      lastVisitTime: json['lastVisitTime'] != null
          ? DateTime.tryParse(json['lastVisitTime'] as String)
          : null,
      totalDurationMinutes: json['totalDurationMinutes'] as int? ?? 0,
      visits: (json['visits'] as List?)
              ?.map((e) =>
                  FieldVisitListItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class MyVisitsResponse {
  MyVisitsResponse({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  final List<FieldVisitDto> items;
  final int totalCount;
  final int page;
  final int pageSize;

  factory MyVisitsResponse.fromJson(Map<String, dynamic> json) {
    return MyVisitsResponse(
      items: (json['items'] as List?)
              ?.map((e) => FieldVisitDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
    );
  }
}

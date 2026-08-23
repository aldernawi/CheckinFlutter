enum VisitStatus { completed, partial, cancelled, outOfRange, pendingReview }

enum StoreRegistrationType { direct, underMarketer }

class StoreDto {
  StoreDto({
    required this.id,
    required this.storeCode,
    required this.name,
    this.nameAr,
    this.ownerName,
    this.ownerPhone1,
    this.ownerPhone2,
    this.purchasingEmployeeName,
    this.purchasingPhone1,
    this.purchasingPhone2,
    this.email,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.district,
    this.photos = const [],
    this.notes,
    this.radiusInMeters,
    this.registrationType = StoreRegistrationType.direct,
    this.marketerId,
    this.marketerName,
    this.distanceInMeters,
    this.isWithinRange,
    this.visitedToday,
    this.isPrimary = false,
    this.isActive = false,
    this.totalVisits = 0,
    this.lastVisitDate,
  });

  final String id;
  final String storeCode;
  final String name;
  final String? nameAr;
  final String? ownerName;
  final String? ownerPhone1;
  final String? ownerPhone2;
  final String? purchasingEmployeeName;
  final String? purchasingPhone1;
  final String? purchasingPhone2;
  final String? email;
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? district;
  final List<String> photos;
  final String? notes;
  final int? radiusInMeters;
  final StoreRegistrationType registrationType;
  final String? marketerId;
  final String? marketerName;
  final double? distanceInMeters;
  final bool? isWithinRange;
  final bool? visitedToday;
  final bool isPrimary;
  final bool isActive;
  final int totalVisits;
  final DateTime? lastVisitDate;

  String get displayName => nameAr ?? name;

  factory StoreDto.fromJson(Map<String, dynamic> json) {
    return StoreDto(
      id: json['id'] as String,
      storeCode: json['storeCode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
      ownerName: json['ownerName'] as String?,
      ownerPhone1: json['ownerPhone1'] as String?,
      ownerPhone2: json['ownerPhone2'] as String?,
      purchasingEmployeeName: json['purchasingEmployeeName'] as String?,
      purchasingPhone1: json['purchasingPhone1'] as String?,
      purchasingPhone2: json['purchasingPhone2'] as String?,
      email: json['email'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      address: json['address'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      photos: (json['photos'] as List?)?.map((e) => e as String).toList() ?? [],
      notes: json['notes'] as String?,
      radiusInMeters: json['radiusInMeters'] as int?,
      registrationType: json['registrationType'] == 2
          ? StoreRegistrationType.underMarketer
          : StoreRegistrationType.direct,
      marketerId: json['marketerId'] as String?,
      marketerName: json['marketerName'] as String?,
      distanceInMeters: (json['distanceInMeters'] as num?)?.toDouble(),
      isWithinRange: json['isWithinRange'] as bool?,
      visitedToday: json['visitedToday'] as bool?,
      isPrimary: json['isPrimary'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? false,
      totalVisits: json['totalVisits'] as int? ?? 0,
      lastVisitDate: json['lastVisitDate'] != null
          ? DateTime.tryParse(json['lastVisitDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'storeCode': storeCode,
        'name': name,
        'nameAr': nameAr,
        'ownerName': ownerName,
        'ownerPhone1': ownerPhone1,
        'ownerPhone2': ownerPhone2,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'city': city,
        'district': district,
        'photos': photos,
        'notes': notes,
        'radiusInMeters': radiusInMeters,
        'registrationType': registrationType == StoreRegistrationType.underMarketer ? 2 : 1,
        'distanceInMeters': distanceInMeters,
        'isWithinRange': isWithinRange,
        'visitedToday': visitedToday,
        'isPrimary': isPrimary,
        'isActive': isActive,
        'totalVisits': totalVisits,
      };
}

class StoreListItemDto {
  StoreListItemDto({
    required this.id,
    required this.storeCode,
    required this.name,
    this.nameAr,
    this.ownerName,
    this.ownerPhone1,
    this.registrationType = StoreRegistrationType.direct,
    this.marketerName,
    this.city,
    this.district,
    required this.latitude,
    required this.longitude,
    this.isActive = false,
    this.assignmentsCount = 0,
    this.visitsCount = 0,
    this.totalVisits = 0,
    this.lastVisitDate,
    this.distanceInMeters,
    required this.createdAt,
  });

  final String id;
  final String storeCode;
  final String name;
  final String? nameAr;
  final String? ownerName;
  final String? ownerPhone1;
  final StoreRegistrationType registrationType;
  final String? marketerName;
  final String? city;
  final String? district;
  final double latitude;
  final double longitude;
  final bool isActive;
  final int assignmentsCount;
  final int visitsCount;
  final int totalVisits;
  final DateTime? lastVisitDate;
  final double? distanceInMeters;
  final DateTime createdAt;

  String get displayName => nameAr ?? name;

  factory StoreListItemDto.fromJson(Map<String, dynamic> json) {
    return StoreListItemDto(
      id: json['id'] as String,
      storeCode: json['storeCode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
      ownerName: json['ownerName'] as String?,
      ownerPhone1: json['ownerPhone1'] as String?,
      registrationType: json['registrationType'] == 2
          ? StoreRegistrationType.underMarketer
          : StoreRegistrationType.direct,
      marketerName: json['marketerName'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      assignmentsCount: json['assignmentsCount'] as int? ?? 0,
      visitsCount: json['visitsCount'] as int? ?? 0,
      totalVisits: json['totalVisits'] as int? ?? 0,
      lastVisitDate: json['lastVisitDate'] != null
          ? DateTime.tryParse(json['lastVisitDate'] as String)
          : null,
      distanceInMeters: (json['distanceInMeters'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class MyStoresResponse {
  MyStoresResponse({
    required this.stores,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  final List<StoreListItemDto> stores;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  factory MyStoresResponse.fromJson(Map<String, dynamic> json) {
    return MyStoresResponse(
      stores: (json['stores'] as List?)
              ?.map((e) => StoreListItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

class CreateStoreRequest {
  CreateStoreRequest({
    required this.name,
    this.nameAr,
    this.ownerName,
    this.ownerPhone1,
    this.ownerPhone2,
    this.purchasingEmployeeName,
    this.purchasingPhone1,
    this.purchasingPhone2,
    this.email,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.district,
    this.photos,
    this.notes,
    this.radiusInMeters,
    this.registrationType = StoreRegistrationType.direct,
    this.marketerId,
  });

  final String name;
  final String? nameAr;
  final String? ownerName;
  final String? ownerPhone1;
  final String? ownerPhone2;
  final String? purchasingEmployeeName;
  final String? purchasingPhone1;
  final String? purchasingPhone2;
  final String? email;
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? district;
  final List<String>? photos;
  final String? notes;
  final int? radiusInMeters;
  final StoreRegistrationType registrationType;
  final String? marketerId;

  Map<String, dynamic> toJson() => {
        'name': name,
        'nameAr': nameAr,
        'ownerName': ownerName,
        'ownerPhone1': ownerPhone1,
        'ownerPhone2': ownerPhone2,
        'purchasingEmployeeName': purchasingEmployeeName,
        'purchasingPhone1': purchasingPhone1,
        'purchasingPhone2': purchasingPhone2,
        'email': email,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'city': city,
        'district': district,
        'photos': photos,
        'notes': notes,
        'radiusInMeters': radiusInMeters,
        'registrationType':
            registrationType == StoreRegistrationType.underMarketer ? 2 : 1,
        'marketerId': marketerId,
      };
}

class CreateStoreResponse {
  CreateStoreResponse({
    required this.id,
    required this.storeCode,
  });

  final String id;
  final String storeCode;

  factory CreateStoreResponse.fromJson(Map<String, dynamic> json) {
    return CreateStoreResponse(
      id: json['id'] as String? ?? '',
      storeCode: json['storeCode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'storeCode': storeCode,
      };
}

class UnvisitedStoreDto {
  UnvisitedStoreDto({
    required this.id,
    required this.storeCode,
    required this.name,
    this.nameAr,
    this.ownerName,
    this.ownerPhone1,
    this.city,
    this.district,
    required this.latitude,
    required this.longitude,
    this.lastVisitDate,
    this.daysSinceLastVisit = 0,
    this.assignedEmployeeName,
  });

  final String id;
  final String storeCode;
  final String name;
  final String? nameAr;
  final String? ownerName;
  final String? ownerPhone1;
  final String? city;
  final String? district;
  final double latitude;
  final double longitude;
  final DateTime? lastVisitDate;
  final int daysSinceLastVisit;
  final String? assignedEmployeeName;

  String get displayName => nameAr ?? name;

  factory UnvisitedStoreDto.fromJson(Map<String, dynamic> json) {
    return UnvisitedStoreDto(
      id: json['id'] as String,
      storeCode: json['storeCode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
      ownerName: json['ownerName'] as String?,
      ownerPhone1: json['ownerPhone1'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      lastVisitDate: json['lastVisitDate'] != null
          ? DateTime.tryParse(json['lastVisitDate'] as String)
          : null,
      daysSinceLastVisit: json['daysSinceLastVisit'] as int? ?? 0,
      assignedEmployeeName: json['assignedEmployeeName'] as String?,
    );
  }
}

class UnvisitedStoresResponse {
  UnvisitedStoresResponse({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  final List<UnvisitedStoreDto> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  factory UnvisitedStoresResponse.fromJson(Map<String, dynamic> json) {
    return UnvisitedStoresResponse(
      items: (json['items'] as List?)
              ?.map((e) => UnvisitedStoreDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

class StoreVisitDto {
  StoreVisitDto({
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
    required this.employeeName,
    this.employeeNameAr,
  });

  final String id;
  final String visitNumber;
  final DateTime visitDate;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final int? durationMinutes;
  final int distanceFromStore;
  final VisitStatus status;
  final String? notes;
  final List<String> photos;
  final String employeeName;
  final String? employeeNameAr;

  factory StoreVisitDto.fromJson(Map<String, dynamic> json) {
    return StoreVisitDto(
      id: json['id'] as String,
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
      status: VisitStatus.values.firstWhere(
        (e) => e.index + 1 == (json['status'] as int? ?? 1),
        orElse: () => VisitStatus.completed,
      ),
      notes: json['notes'] as String?,
      photos: (json['photos'] as List?)?.map((e) => e as String).toList() ?? [],
      employeeName: json['employeeName'] as String? ?? '',
      employeeNameAr: json['employeeNameAr'] as String?,
    );
  }
}

class StoreVisitsResponse {
  StoreVisitsResponse({required this.items, required this.totalCount});

  final List<StoreVisitDto> items;
  final int totalCount;

  factory StoreVisitsResponse.fromJson(Map<String, dynamic> json) {
    return StoreVisitsResponse(
      items: (json['items'] as List?)
              ?.map((e) => StoreVisitDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

class SelfRegisterRequest {
  SelfRegisterRequest({
    required this.fullName,
    required this.phone,
    this.email,
    required this.password,
    required this.branchId,
  });

  final String fullName;
  final String phone;
  final String? email;
  final String password;
  final String branchId;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'password': password,
        'branchId': branchId,
      };
}

class SelfRegisterResponse {
  SelfRegisterResponse({
    required this.employeeId,
    required this.employeeNumber,
    required this.message,
  });

  final String employeeId;
  final String employeeNumber;
  final String message;

  factory SelfRegisterResponse.fromJson(Map<String, dynamic> json) {
    return SelfRegisterResponse(
      employeeId: json['employeeId'] as String? ?? '',
      employeeNumber: json['employeeNumber'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}

class EmployeeDto {
  EmployeeDto({
    required this.id,
    required this.employeeNumber,
    required this.fullName,
    this.fullNameAr,
    this.email,
    required this.phone,
    this.jobTitle,
    this.hireDate,
    this.branch,
    this.department,
    this.shift,
    this.roles = const [],
    this.canWorkRemote = false,
    this.profilePicture,
    this.isActive = true,
    this.employeeType,
  });

  final String id;
  final String employeeNumber;
  final String fullName;
  final String? fullNameAr;
  final String? email;
  final String phone;
  final String? jobTitle;
  final String? hireDate;
  final BranchDto? branch;
  final DepartmentDto? department;
  final ShiftInfoDto? shift;
  final List<String> roles;
  final bool canWorkRemote;
  final String? profilePicture;
  final bool isActive;
  final int? employeeType;

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      id: json['id'] as String? ?? '',
      employeeNumber: json['employeeNumber'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      fullNameAr: json['fullNameAr'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String? ?? '',
      jobTitle: json['jobTitle'] as String?,
      hireDate: json['hireDate'] as String?,
      branch: json['branch'] is Map<String, dynamic>
          ? BranchDto.fromJson(json['branch'] as Map<String, dynamic>)
          : null,
      department: json['department'] is Map<String, dynamic>
          ? DepartmentDto.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      shift: json['shift'] is Map<String, dynamic>
          ? ShiftInfoDto.fromJson(json['shift'] as Map<String, dynamic>)
          : null,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      canWorkRemote: json['canWorkRemote'] as bool? ?? false,
      profilePicture: json['profilePicture'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      employeeType: json['employeeType'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employeeNumber': employeeNumber,
        'fullName': fullName,
        'fullNameAr': fullNameAr,
        'email': email,
        'phone': phone,
        'jobTitle': jobTitle,
        'hireDate': hireDate,
        'branch': branch?.toJson(),
        'department': department?.toJson(),
        'shift': shift?.toJson(),
        'roles': roles,
        'canWorkRemote': canWorkRemote,
        'profilePicture': profilePicture,
        'isActive': isActive,
        'employeeType': employeeType,
      };
}

class BranchDto {
  BranchDto({required this.id, required this.name, this.nameAr});

  final String id;
  final String name;
  final String? nameAr;

  factory BranchDto.fromJson(Map<String, dynamic> json) {
    return BranchDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'nameAr': nameAr};
}

class DepartmentDto {
  DepartmentDto({required this.id, required this.name, this.nameAr});

  final String id;
  final String name;
  final String? nameAr;

  factory DepartmentDto.fromJson(Map<String, dynamic> json) {
    return DepartmentDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'nameAr': nameAr};
}

class ShiftInfoDto {
  ShiftInfoDto({
    required this.id,
    required this.name,
    this.nameAr,
    required this.startTime,
    required this.endTime,
  });

  final String id;
  final String name;
  final String? nameAr;
  final String startTime;
  final String endTime;

  factory ShiftInfoDto.fromJson(Map<String, dynamic> json) {
    return ShiftInfoDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['nameAr'] as String?,
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'nameAr': nameAr, 'startTime': startTime, 'endTime': endTime};
}

import 'dart:convert';

import 'package:checkin_flutter/core/models/employee_dto.dart';

String encodeEmployeeCache(EmployeeDto employee) =>
    jsonEncode(employee.toJson());

EmployeeDto? decodeEmployeeCache(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  try {
    final decoded = jsonDecode(value);
    return decoded is Map<String, dynamic>
        ? EmployeeDto.fromJson(decoded)
        : null;
  } on FormatException {
    // Older builds persisted Map.toString(), which is not valid JSON.
    return null;
  }
}

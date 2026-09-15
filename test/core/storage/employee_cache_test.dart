import 'package:checkin_flutter/core/models/employee_dto.dart';
import 'package:checkin_flutter/core/storage/employee_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('employee cache is valid JSON and preserves identity fields', () {
    final employee = EmployeeDto(
      id: 'employee-1',
      employeeNumber: 'EMP-1',
      fullName: 'Real User',
      fullNameAr: 'المستخدم الحقيقي',
      email: 'real@example.ly',
      phone: '0911111111',
    );

    final decoded = decodeEmployeeCache(encodeEmployeeCache(employee));

    expect(decoded?.id, employee.id);
    expect(decoded?.phone, employee.phone);
    expect(decoded?.fullNameAr, employee.fullNameAr);
  });

  test(
    'legacy Map.toString cache is rejected instead of shown as user data',
    () {
      expect(
        decodeEmployeeCache('{id: employee-1, phone: 0911111111}'),
        isNull,
      );
    },
  );
}

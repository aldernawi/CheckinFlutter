import 'package:checkin_flutter/core/models/employee_dto.dart';
import 'package:checkin_flutter/core/network/auth_session_manager.dart';
import 'package:checkin_flutter/features/auth/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

EmployeeDto employee({int? type, List<String> roles = const []}) => EmployeeDto(
  id: 'employee-1',
  employeeNumber: '001',
  fullName: 'Test Employee',
  phone: '0910000000',
  employeeType: type,
  roles: roles,
);

void main() {
  test('MAUI field behaviour takes precedence over a manager role', () {
    expect(
      AuthRepository.determineRoleSet(employee(type: 2, roles: ['ADMIN'])),
      AppUserRoleSet.fieldRep,
    );
  });

  test(
    'role matching is case-insensitive and routes to the matching shell',
    () {
      expect(
        AuthRepository.determineRoleSet(employee(roles: ['mAnAgEr'])),
        AppUserRoleSet.manager,
      );
      expect(requestsRouteForRole(AppUserRoleSet.manager), '/manager/requests');
      expect(requestsRouteForRole(AppUserRoleSet.fieldRep), '/field/requests');
    },
  );
}

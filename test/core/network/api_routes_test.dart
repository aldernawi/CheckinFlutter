import 'package:checkin_flutter/core/network/api_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses official NMC routes for authenticated workflows', () {
    expect(ApiRoutes.login, 'api/v1/auth/login');
    expect(ApiRoutes.registerDevice, 'api/v1/auth/register-device');
    expect(ApiRoutes.teamAttendance, 'api/v1/attendance/team');
    expect(ApiRoutes.pendingRequests, 'api/v1/requests/pending');
    expect(ApiRoutes.visitHistory, 'api/v1/visits/history');
    expect(ApiRoutes.changePassword, 'api/v1/auth/change-password');
    expect(ApiRoutes.myProfile, 'api/v1/employees/me');
  });

  test('builds official identifier routes without legacy prefixes', () {
    expect(ApiRoutes.requestApprove('request-1'), 'api/v1/requests/request-1/approve');
    expect(ApiRoutes.visitEnd('visit-1'), 'api/v1/visits/visit-1/end');
    expect(ApiRoutes.authDevice('device-1'), 'api/v1/auth/devices/device-1');
  });
}

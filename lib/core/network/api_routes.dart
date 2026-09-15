class ApiRoutes {
  const ApiRoutes._();

  static const login = 'api/v1/auth/login';
  static const refresh = 'api/v1/auth/refresh';
  static const selfRegister = 'api/v1/auth/self-register';
  static const registerDevice = 'api/v1/auth/register-device';
  static const authDevices = 'api/v1/auth/devices';
  static String authDevice(String deviceId) => 'api/v1/auth/devices/$deviceId';

  static const changePassword = 'api/v1/auth/change-password';
  static const myProfile = 'api/v1/employees/me';
  static const deleteMyAccount = 'api/v1/employees/me/account';
  static const branchesLookup = 'api/v1/branches/lookup';

  static const attendanceStatus = 'api/v1/attendance/status';
  static const attendanceCheckin = 'api/v1/attendance/checkin';
  static const attendanceCheckout = 'api/v1/attendance/checkout';
  static const attendanceHistory = 'api/v1/attendance/history';
  static const teamAttendance = 'api/v1/attendance/team';
  static const attendanceSync = 'api/v1/attendance/sync';
  static const nearbyLocations = 'api/v1/locations/nearby';

  static const myRequests = 'api/v1/employees/me/requests';
  static const requests = 'api/v1/requests';
  static const pendingRequests = 'api/v1/requests/pending';
  static String request(String id) => 'api/v1/requests/$id';
  static String requestCancel(String id) => '${request(id)}/cancel';
  static String requestApprove(String id) => '${request(id)}/approve';
  static String requestReject(String id) => '${request(id)}/reject';

  static const visits = 'api/v1/visits';
  static const todayVisits = 'api/v1/visits/today';
  static const visitHistory = 'api/v1/visits/history';
  static String visitEnd(String id) => 'api/v1/visits/$id/end';

  static const myStores = 'api/v1/stores/my';
  static const stores = 'api/v1/stores';
  static const unvisitedStores = 'api/v1/stores/unvisited';
  static String store(String id) => 'api/v1/stores/$id';
}

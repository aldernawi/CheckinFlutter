import 'package:checkin_flutter/core/network/auth_session_manager.dart';

class RouteGuards {
  const RouteGuards._();

  static bool canAccessManagerRoutes(AppUserRoleSet roleSet) {
    return roleSet == AppUserRoleSet.manager;
  }

  static bool canAccessFieldRoutes(AppUserRoleSet roleSet) {
    return roleSet == AppUserRoleSet.fieldRep;
  }
}

import 'package:checkin_flutter/app/router/route_guards.dart';
import 'package:checkin_flutter/app/router/route_names.dart';
import 'package:checkin_flutter/core/network/auth_session_manager.dart';
import 'package:checkin_flutter/features/attendance/presentation/check_in_page.dart';
import 'package:checkin_flutter/features/attendance/presentation/check_out_page.dart';
import 'package:checkin_flutter/features/auth/presentation/forgot_password_page.dart';
import 'package:checkin_flutter/features/auth/presentation/login_page.dart';
import 'package:checkin_flutter/features/auth/presentation/register_page.dart';
import 'package:checkin_flutter/features/calendar/presentation/calendar_page.dart';
import 'package:checkin_flutter/features/devices/presentation/devices_page.dart';
import 'package:checkin_flutter/features/field_visits/presentation/field_visits_page.dart';
import 'package:checkin_flutter/features/field_visits/presentation/map_picker_page.dart';
import 'package:checkin_flutter/features/field_visits/presentation/record_visit_page.dart';
import 'package:checkin_flutter/features/field_visits/presentation/visit_history_page.dart';
import 'package:checkin_flutter/features/history/presentation/attendance_details_page.dart';
import 'package:checkin_flutter/features/history/presentation/history_page.dart';
import 'package:checkin_flutter/features/home/presentation/home_page.dart';
import 'package:checkin_flutter/features/profile/presentation/change_password_page.dart';
import 'package:checkin_flutter/features/profile/presentation/edit_profile_page.dart';
import 'package:checkin_flutter/features/profile/presentation/profile_page.dart';
import 'package:checkin_flutter/features/requests/presentation/new_request_page.dart';
import 'package:checkin_flutter/features/requests/presentation/request_details_page.dart';
import 'package:checkin_flutter/features/requests/presentation/requests_page.dart';
import 'package:checkin_flutter/features/settings/presentation/delete_account_page.dart';
import 'package:checkin_flutter/features/settings/presentation/privacy_policy_page.dart';
import 'package:checkin_flutter/features/settings/presentation/settings_page.dart';
import 'package:checkin_flutter/features/settings/presentation/terms_of_service_page.dart';
import 'package:checkin_flutter/features/stores/presentation/add_store_page.dart';
import 'package:checkin_flutter/features/stores/presentation/edit_store_page.dart';
import 'package:checkin_flutter/features/stores/presentation/store_details_page.dart';
import 'package:checkin_flutter/features/stores/presentation/stores_map_page.dart';
import 'package:checkin_flutter/features/stores/presentation/stores_page.dart';
import 'package:checkin_flutter/features/stores/presentation/unvisited_stores_page.dart';
import 'package:checkin_flutter/features/team/presentation/pending_requests_page.dart';
import 'package:checkin_flutter/features/team/presentation/team_attendance_page.dart';
import 'package:checkin_flutter/features/team/presentation/team_member_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(authSessionProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthRoute = state.fullPath == '/login' ||
          state.fullPath == '/forgot-password' ||
          state.fullPath == '/register';

      if (!session.isAuthenticated) {
        return isAuthRoute ? null : '/login';
      }

      if (isAuthRoute) {
        switch (session.roleSet) {
          case AppUserRoleSet.manager:
            return '/manager/home';
          case AppUserRoleSet.fieldRep:
            return '/field/home';
          case AppUserRoleSet.employee:
            return '/main/home';
        }
      }

      if (state.fullPath?.startsWith('/manager') == true &&
          !RouteGuards.canAccessManagerRoutes(session.roleSet)) {
        return '/main/home';
      }

      if (state.fullPath?.startsWith('/field') == true &&
          !RouteGuards.canAccessFieldRoutes(session.roleSet)) {
        return '/main/home';
      }

      if (state.fullPath == '/') {
        switch (session.roleSet) {
          case AppUserRoleSet.manager:
            return '/manager/home';
          case AppUserRoleSet.fieldRep:
            return '/field/home';
          case AppUserRoleSet.employee:
            return '/main/home';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            EmployeeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/home',
                name: RouteNames.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/requests',
                name: RouteNames.requests,
                builder: (context, state) => const RequestsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/history',
                name: RouteNames.history,
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/profile',
                name: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ManagerShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager/team',
                name: RouteNames.teamAttendance,
                builder: (context, state) => const TeamAttendancePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager/requests',
                builder: (context, state) => const RequestsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager/history',
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manager/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            FieldRepShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/field/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/field/visits',
                name: RouteNames.fieldVisits,
                builder: (context, state) => const FieldVisitsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/field/requests',
                builder: (context, state) => const RequestsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/field/history',
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/field/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/check-in',
        name: RouteNames.checkIn,
        builder: (context, state) => const CheckInPage(),
      ),
      GoRoute(
        path: '/check-out',
        name: RouteNames.checkOut,
        builder: (context, state) => const CheckOutPage(),
      ),
      GoRoute(
        path: '/new-request',
        name: RouteNames.newRequest,
        builder: (context, state) => const NewRequestPage(),
      ),
      GoRoute(
        path: '/request/:requestId',
        name: RouteNames.requestDetails,
        builder: (context, state) =>
            RequestDetailsPage(requestId: state.pathParameters['requestId']!),
      ),
      GoRoute(
        path: '/attendance/:attendanceId',
        name: RouteNames.attendanceDetails,
        builder: (context, state) => AttendanceDetailsPage(
          attendanceId: state.pathParameters['attendanceId']!,
        ),
      ),
      GoRoute(
        path: '/devices',
        name: RouteNames.devices,
        builder: (context, state) => const DevicesPage(),
      ),
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/privacy-policy',
        name: RouteNames.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: '/terms-of-service',
        name: RouteNames.termsOfService,
        builder: (context, state) => const TermsOfServicePage(),
      ),
      GoRoute(
        path: '/delete-account',
        name: RouteNames.deleteAccount,
        builder: (context, state) => const DeleteAccountPage(),
      ),
      GoRoute(
        path: '/change-password',
        name: RouteNames.changePassword,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/pending-requests',
        name: RouteNames.pendingRequests,
        builder: (context, state) => const PendingRequestsPage(),
      ),
      GoRoute(
        path: '/team/:memberId',
        name: RouteNames.teamMemberDetails,
        builder: (context, state) => TeamMemberDetailsPage(
          memberId: state.pathParameters['memberId']!,
        ),
      ),
      GoRoute(
        path: '/calendar',
        name: RouteNames.calendar,
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: '/stores',
        name: RouteNames.myStores,
        builder: (context, state) => const StoresPage(),
      ),
      GoRoute(
        path: '/stores/add',
        name: RouteNames.addStore,
        builder: (context, state) => const AddStorePage(),
      ),
      GoRoute(
        path: '/stores/:storeId',
        name: RouteNames.storeDetails,
        builder: (context, state) =>
            StoreDetailsPage(storeId: state.pathParameters['storeId']!),
      ),
      GoRoute(
        path: '/stores/:storeId/edit',
        name: RouteNames.editStore,
        builder: (context, state) =>
            EditStorePage(storeId: state.pathParameters['storeId']!),
      ),
      GoRoute(
        path: '/stores/unvisited',
        name: RouteNames.unvisitedStores,
        builder: (context, state) => const UnvisitedStoresPage(),
      ),
      GoRoute(
        path: '/stores-map',
        name: RouteNames.storesMap,
        builder: (context, state) => const StoresMapPage(),
      ),
      GoRoute(
        path: '/record-visit/:storeId',
        name: RouteNames.recordVisit,
        builder: (context, state) =>
            RecordVisitPage(storeId: state.pathParameters['storeId']!),
      ),
      GoRoute(
        path: '/map-picker',
        name: RouteNames.mapPicker,
        builder: (context, state) => const MapPickerPage(),
      ),
      GoRoute(
        path: '/visit-history',
        name: RouteNames.visitHistory,
        builder: (context, state) => const VisitHistoryPage(),
      ),
    ],
  );
});

class EmployeeShell extends StatelessWidget {
  const EmployeeShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return _AppRoleShell(
      navigationShell: navigationShell,
      labels: const ['الرئيسية', 'طلباتي', 'سجلي', 'حسابي'],
      icons: const [
        Icons.home_outlined,
        Icons.assignment_outlined,
        Icons.history_outlined,
        Icons.person_outline,
      ],
    );
  }
}

class ManagerShell extends StatelessWidget {
  const ManagerShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return _AppRoleShell(
      navigationShell: navigationShell,
      labels: const ['الرئيسية', 'فريقي', 'طلباتي', 'سجلي', 'حسابي'],
      icons: const [
        Icons.home_outlined,
        Icons.groups_outlined,
        Icons.assignment_outlined,
        Icons.history_outlined,
        Icons.person_outline,
      ],
    );
  }
}

class FieldRepShell extends StatelessWidget {
  const FieldRepShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return _AppRoleShell(
      navigationShell: navigationShell,
      labels: const ['الرئيسية', 'زياراتي', 'طلباتي', 'سجلي', 'حسابي'],
      icons: const [
        Icons.home_outlined,
        Icons.place_outlined,
        Icons.assignment_outlined,
        Icons.history_outlined,
        Icons.person_outline,
      ],
    );
  }
}

class _AppRoleShell extends StatelessWidget {
  const _AppRoleShell({
    required this.navigationShell,
    required this.labels,
    required this.icons,
  });

  final StatefulNavigationShell navigationShell;
  final List<String> labels;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          for (var i = 0; i < labels.length; i++)
            NavigationDestination(icon: Icon(icons[i]), label: labels[i]),
        ],
      ),
    );
  }
}

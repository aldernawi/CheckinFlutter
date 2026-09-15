import 'package:checkin_flutter/app/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

bool containsPath(List<RouteBase> routes, String path) {
  for (final route in routes) {
    if (route is GoRoute && route.path == path) {
      return true;
    }
    if (route is ShellRouteBase && containsPath(route.routes, path)) {
      return true;
    }
  }
  return false;
}

void main() {
  test('router registers the restoration root location', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    addTearDown(router.dispose);

    expect(containsPath(router.configuration.routes, '/'), isTrue);
  });
}

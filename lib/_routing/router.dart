import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';

final class MenoRouter {
  MenoRouter(this._auth);

  final AuthManager _auth;

  late final GoRouter routerConfig = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: R.home,
    redirect: (context, state) {
      final nextRoute = state.matchedLocation;
      final isPublicRoute = R.publicRoutes.contains(nextRoute);
      final isAuthenticated = _auth.activeUserId.value.isValid;

      if (!isAuthenticated) {
        if (!isPublicRoute) {
          if (nextRoute.contains('switch-account')) return null;
          return R.login;
        }
        return null;
      }

      if (isPublicRoute) return R.home;
      return null;
    },
    refreshListenable: di<AuthManager>().activeUserId,
    routes: [
      GoRoute(path: R.loading, builder: (_, _) => const LoadingPage()),

      GoRoute(
        path: '/switch-account/:id',
        builder: (context, state) {
          final userId = state.pathParameters['id'] ?? '';
          return SwitchAccountPage(userIdStr: userId);
        },
      ),

      GoRoute(path: R.login, builder: (_, _) => const LoginPage()),
    ],
  );
}

extension AppRouterExtensions on BuildContext {
  /// Pops the [BuildContext] [count] number of times.
  ///
  /// For example, to pop twice: context.popCount(2);
  void popCount(int count) {
    var popped = 0;
    Navigator.of(this).popUntil((_) => popped++ >= count);
  }

  /// Alias for semantic clarity if you prefer "pop multiple"
  void popMultiple(int count) => popCount(count);

  void popUntil(String targetPathName) {
    return Navigator.of(
      this,
    ).popUntil((r) => r.settings.name == targetPathName);
  }
}

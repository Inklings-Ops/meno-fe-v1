import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:meno_auth/meno_auth.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_domain/meno_domain.dart' show MRoutes;
import 'package:meno_onboarding/meno_onboarding.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final menoRouterConfig = Computed(() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        name: MRoutes.root_,
        path: MRoutes.root,
        builder: (_, state) => const Scaffold(body: MLoadingIndicator.box()),
      ),
      GoRoute(
        name: MRoutes.onboarding_,
        path: MRoutes.onboarding,
        builder: (_, state) => const OnboardingPage(),
      ),
      GoRoute(
        name: MRoutes.login_,
        path: MRoutes.loginPath,
        builder: (_, state) => const LoginPage(),
      ),
    ],
  );
});

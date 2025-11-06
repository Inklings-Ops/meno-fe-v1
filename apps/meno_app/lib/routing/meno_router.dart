import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_auth/meno_auth.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_domain/meno_domain.dart' show MRoutes;
import 'package:meno_onboarding/meno_onboarding.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final menoRouterConfig = GoRouter(
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
  redirect: (context, state) {
    final next = state.matchedLocation;

    final onboardingController = OnboardingController.provider.of(context);
    final allowedOnboardingRoutes = [MRoutes.loginPath, MRoutes.registerPath];
    if (!onboardingController.isOnboardingComplete()) {
      if (allowedOnboardingRoutes.contains(next)) return null;
      return next == MRoutes.onboarding ? null : MRoutes.onboarding;
    }

    return null;
  },
);

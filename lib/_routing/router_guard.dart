import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';
import 'package:meno/features/onboarding/manager/onboarding_manager.dart';

final class RouterGuard {
  const RouterGuard({
    required AuthManager auth,
    required OnboardingManager onboarding,
  }) : _auth = auth,
       _onboarding = onboarding;

  final AuthManager _auth;
  final OnboardingManager _onboarding;

  /// Called by GoRouter on every navigation event.
  /// Returns the redirect target, or null to allow the navigation.
  String? call(BuildContext context, GoRouterState state) {
    final route = state.matchedLocation;
    final isPublic = R.publicRoutes.contains(route);
    final isOnboarded = _onboarding.isOnboarded.value;
    final isAuthed = _auth.activeUserId.value.isValid;
    final isVerified = _auth.emailVerified.value;

    // Onboarding gate — must complete before anything else.
    if (!isOnboarded) return isPublic ? null : R.onboarding;

    // Authentication gate.
    if (!isAuthed) {
      if (route.contains('switch-account')) return null;
      return isPublic ? null : R.login;
    }

    // Email verification gate.
    if (!isVerified) {
      return route == R.emailVerification ? null : R.emailVerification;
    }

    // Authenticated users must not linger on public/auth screens.
    if (isPublic) return R.home;

    return null;
  }
}

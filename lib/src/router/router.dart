import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/application/auth/auth_notifier.dart';
import '../features/auth/presentation/pages/login/login_page.dart';
import '../features/auth/presentation/pages/register/email_verification_page.dart';
import '../features/auth/presentation/pages/register/register_page.dart';
import '../features/auth/presentation/pages/reset_password/create_new_password_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_otp_verification_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_success_page.dart';
import '../features/broadcast/presentation/pages/create_broadcast/create_broadcast_page.dart';
import '../features/broadcast/presentation/pages/home_page.dart';
import '../features/onboarding/onboarding.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../layout/presentation/pages/app_layout.dart';
import '../layout/presentation/pages/pages.dart';
import '../services/socket_service/socket_service.dart';
import '../shared/pages/loading_page.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

@riverpod
GoRouter router(RouterRef ref) {
  final bool isOnboarded = ref.read(onboardingProvider).isOnboarded();
  final AuthStatus status = ref.watch(authProvider).status;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: isOnboarded ? Routes.home : Routes.onboarding,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.onboarding,
        name: Routes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        builder: (context, state) {
          final isPasswordOnly = state.uri.queryParameters["isPasswordOnly"];
          final implyLeading = state.uri.queryParameters["implyLeading"];

          return LoginPage(
            implyLeading: implyLeading == "true" ? true : false,
            isPasswordOnly: isPasswordOnly == "true" ? true : false,
          );
        },
      ),
      GoRoute(
        path: Routes.register,
        name: Routes.register,
        builder: (context, state) {
          final implyLeading = state.uri.queryParameters["implyLeading"];

          return RegisterPage(implyLeading: implyLeading == "true");
        },
      ),
      GoRoute(
        path: Routes.resetPassword,
        name: Routes.resetPassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: Routes.resetPasswordOtp,
        name: Routes.resetPasswordOtp,
        builder: (context, state) => const ResetPasswordOtpVerificationPage(),
      ),
      GoRoute(
        path: Routes.resetPasswordSuccess,
        name: Routes.resetPasswordSuccess,
        builder: (context, state) => const ResetPasswordSuccessPage(),
      ),
      GoRoute(
        path: Routes.createNewPassword,
        name: Routes.createNewPassword,
        builder: (context, state) => const CreateNewPasswordPage(),
      ),
      GoRoute(
        path: Routes.emailVerification,
        name: Routes.emailVerification,
        builder: (context, state) => const EmailVerificationPage(),
      ),
      GoRoute(
        path: Routes.loading,
        name: Routes.loading,
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(
        path: Routes.createBroadcast,
        name: Routes.createBroadcast,
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const CreateBroadcastPage(),
            barrierDismissible: true,
            barrierColor: Colors.black38,
            opaque: false,
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnim, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppLayout(child: child),
        routes: <RouteBase>[
          GoRoute(
            path: Routes.home,
            name: Routes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: Routes.discover,
            name: Routes.discover,
            builder: (context, state) => const DiscoverPage(),
          ),
          GoRoute(
            path: Routes.notes,
            name: Routes.notes,
            builder: (context, state) => const NotesPage(),
          ),
          GoRoute(
            path: Routes.profile,
            name: Routes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      final bool isRegister = state.matchedLocation == Routes.register;

      if (isOnboarded) {
        if (status == AuthStatus.partiallyAuthenticated && isRegister) {
          return "/register?implyLeading=false";
        }

        if (status == AuthStatus.unauthenticated && isRegister) {
          return "/register?implyLeading=true";
        }

        if (status == AuthStatus.partiallyAuthenticated) {
          return "/login?isPasswordOnly=true";
        }

        if (status == AuthStatus.unauthenticated) {
          return "/login?isPasswordOnly=false";
        }

        ref.watch(socketServiceProvider.notifier);
        return null;
      }
      return null;
    },
  );
}

class Routes {
  Routes._();

  static const String onboarding = "/onboarding";
  static const String login = "/login";
  static const String returnLogin = "/returnLogin";
  static const String register = "/register";
  static const String emailVerification = "/emailVerification";
  static const String loading = "/loading";
  static const String resetPassword = "/resetPassword";
  static const String resetPasswordOtp = "/resetPasswordOtp";
  static const String resetPasswordSuccess = "/resetPasswordSuccess";
  static const String createNewPassword = "/createNewPassword";
  static const String broadcast = "/broadcast";
  static const String stream = "/stream";
  static const String layout = "/";
  static const String createBroadcast = "/createBroadcast";
  static const String home = "/home";
  static const String discover = "/discover";
  static const String notes = "/notes";
  static const String profile = "/profile";
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast_list/broadcast_list_provider.dart';
import 'package:meno_fe_v1/src/features/profile/application/application.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/application/auth/auth_notifier.dart';
import '../features/auth/presentation/pages/login/login_page.dart';
import '../features/auth/presentation/pages/register/email_verification_page.dart';
import '../features/auth/presentation/pages/register/register_page.dart';
import '../features/auth/presentation/pages/reset_password/create_new_password_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_otp_verification_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_success_page.dart';
import '../features/bible/presentation/pages/bible_page.dart';
import '../features/broadcast/domain/domain.dart';
import '../features/broadcast/presentation/pages/broadcast/broadcast_page.dart';
import '../features/broadcast/presentation/pages/create_broadcast/create_broadcast_page.dart';
import '../features/broadcast/presentation/pages/home/details_page.dart';
import '../features/broadcast/presentation/pages/home/home_page.dart';
import '../features/broadcast/presentation/pages/home/recently_live_page.dart';
import '../features/broadcast/presentation/pages/stream/stream_page.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/notifications/application/notifications_notifier.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/onboarding/onboarding.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../layout/m_layout.dart';
import '../layout/pages.dart';
import '../services/socket/socket_service.dart';
import '../shared/pages/loading_page.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true, dependencies: [SocketService, NotificationsNotifier])
GoRouter router(RouterRef ref) {
  final isOnboarded = ref.watch(onboardingProvider).isOnboarded;

  final status = ref.watch(authProvider).status;
  final isUnAuth = status == AuthStatus.unauthenticated;
  final isPartiallyAuth = status == AuthStatus.partiallyAuthenticated;

  ref.listen(onboardingProvider, (previous, next) {
    if (previous?.isOnboarded != next.isOnboarded) {
      ref.invalidateSelf();
    }
  });

  ref.listen(authProvider, (previous, next) {
    if (previous?.token != next.token) {
      ref.invalidateSelf();
      ref.invalidate(socketServiceProvider);
      ref.invalidate(recentBroadcastsProvider);
      ref.invalidate(myProfileProvider);
      ref.read(myProfileProvider.future);
      ref.invalidate(notificationsNotifierProvider);
      ref.read(notificationsNotifierProvider.notifier).getNotifications();
      // ref.invalidate(sortNotificationsProvider);
    }
  });

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: isOnboarded ? Routes.home : Routes.onboarding,
    debugLogDiagnostics: true,
    // refreshListenable: ref.watch(authProvider.notifier).listener,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.onboarding,
        name: Routes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: Routes.createBroadcast,
        name: Routes.createBroadcast,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CreateBroadcastPage(),
      ),
      GoRoute(
        path: Routes.broadcast,
        name: Routes.broadcast,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const BroadcastPage(),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        builder: (context, state) {
          final isPasswordOnly = state.uri.queryParameters['isPasswordOnly'];
          final implyLeading = state.uri.queryParameters['implyLeading'];

          return LoginPage(
            implyLeading: implyLeading == 'true' ? true : false,
            isPasswordOnly: isPasswordOnly == 'true' ? true : false,
          );
        },
      ),
      GoRoute(
        path: Routes.register,
        name: Routes.register,
        builder: (context, state) {
          final implyLeading = state.uri.queryParameters['implyLeading'];

          return RegisterPage(
            implyLeading: implyLeading == 'true' ? true : false,
          );
        },
      ),
      GoRoute(
        path: Routes.resetPassword,
        name: Routes.resetPassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: Routes.resetPwdOtp,
        name: Routes.resetPwdOtp,
        builder: (context, state) => const ResetPasswordOtpVerificationPage(),
      ),
      GoRoute(
        path: Routes.resetPwdSuccess,
        name: Routes.resetPwdSuccess,
        builder: (context, state) => const ResetPasswordSuccessPage(),
      ),
      GoRoute(
        path: Routes.createNewPassword,
        name: Routes.createNewPassword,
        parentNavigatorKey: rootNavigatorKey,
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
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(
        path: Routes.stream,
        name: Routes.stream,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const StreamPage(),
      ),
      GoRoute(
        path: Routes.recentlyLive,
        name: Routes.recentlyLive,
        builder: (context, state) => const RecentlyLivePage(),
        parentNavigatorKey: rootNavigatorKey,
      ),
      GoRoute(
        path: Routes.details,
        name: Routes.details,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final broadcast = (state.extra) as Broadcast;
          return DetailsPage(broadcast: broadcast);
        },
      ),
      GoRoute(
        path: Routes.notifications,
        name: Routes.notifications,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/chat',
        name: '/chat',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ChatPage(),
      ),
      GoRoute(
        path: '/bible',
        name: '/bible',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const BiblePage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MLayout(shell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.home,
                name: Routes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.discover,
                name: Routes.discover,
                builder: (context, state) => const DiscoverPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.notes,
                name: Routes.notes,
                builder: (context, state) => const NotesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.profile,
                name: Routes.profile,
                builder: (context, state) => ProfilePage(
                  id: state.extra as String?,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isRegister = state.matchedLocation == Routes.register;
      final isResetPassword = state.matchedLocation == Routes.resetPassword;
      final isRPasswordOtp = state.matchedLocation == Routes.resetPwdOtp;
      final isResetSuccess = state.matchedLocation == Routes.resetPwdSuccess;
      final isVerification = state.matchedLocation == Routes.emailVerification;
      final isLogin = state.matchedLocation == Routes.login;

      if (isRegister) return Routes.registerWithLeading;
      if (isResetPassword) return Routes.resetPassword;
      if (isRPasswordOtp) return Routes.resetPwdOtp;
      if (isResetSuccess) return Routes.resetPwdSuccess;
      if (isVerification) return Routes.emailVerification;

      if (!isOnboarded) {
        if (isLogin) return Routes.loginWithLeading;
        return null;
      } else {
        if (isPartiallyAuth) return Routes.partialLogin;
        if (isUnAuth) return Routes.login;
        return null;
      }
    },
  );
}

class Routes {
  Routes._();

  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String loginWithLeading = '/login?implyLeading=true';
  static const String partialLogin = '/login?isPasswordOnly=true';
  static const String returnLogin = '/returnLogin';
  static const String register = '/register';
  static const String registerWithoutLeading = '/register?implyLeading=false';
  static const String registerWithLeading = '/register?implyLeading=true';
  static const String emailVerification = '/emailVerification';
  static const String loading = '/loading';
  static const String resetPassword = '/resetPassword';
  static const String resetPwdOtp = '/resetPasswordOtp';
  static const String resetPwdSuccess = '/resetPasswordSuccess';
  static const String createNewPassword = '/createNewPassword';
  static const String broadcast = '/broadcast';
  static const String createBroadcast = '/createBroadcast';
  static const String stream = '/stream';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String notes = '/notes';
  static const String profile = '/profile';
  static const String recentlyLive = '/recentlyLive';
  static const String details = '/details';
  static const String notifications = '/notifications';
}

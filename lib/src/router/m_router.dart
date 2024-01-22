import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/onboarding/application/onboarding_cubit.dart';
import 'package:meno_fe_v1/src/shared/pages/start_up/startup_page.dart';

import '../features/auth/application/application.dart';
import '../features/auth/presentation/pages/login/login_page.dart';
import '../features/auth/presentation/pages/register/email_verification_page.dart';
import '../features/auth/presentation/pages/register/register_page.dart';
import '../features/auth/presentation/pages/reset_password/create_new_password_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_otp_verification_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_success_page.dart';
import '../features/bible/presentation/pages/bible_page.dart';
import '../features/broadcast/domain/entities/broadcast.dart';
import '../features/broadcast/presentation/pages/broadcast/broadcast_page.dart';
import '../features/broadcast/presentation/pages/create_broadcast/create_broadcast_page.dart';
import '../features/broadcast/presentation/pages/home/details_page.dart';
import '../features/broadcast/presentation/pages/home/home_page.dart';
import '../features/broadcast/presentation/pages/home/recently_live_page.dart';
import '../features/broadcast/presentation/pages/stream/stream_page.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../shared/layout/m_layout.dart';
import '../shared/layout/pages.dart';
import 'm_routes.dart';

@Injectable()
class MRouter {
  final AuthBloc authBloc;
  final OnboardingCubit onboardingCubit;

  MRouter({required this.authBloc, required this.onboardingCubit});

  final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  late final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    // redirect: (context, state) {
    //   // final isUnAuth = authBloc.state.status == AuthStatus.unauthenticated;
    //   // final isPartiallyAuth =
    //   //     authBloc.state.status == AuthStatus.partiallyAuthenticated;

    //   // final isRegister = state.matchedLocation == Routes.register;
    //   // final isResetPassword = state.matchedLocation == Routes.resetPassword;
    //   // final isRPasswordOtp = state.matchedLocation == Routes.resetPwdOtp;
    //   // final isResetSuccess = state.matchedLocation == Routes.resetPwdSuccess;
    //   // final isVerification = state.matchedLocation == Routes.emailVerification;
    //   // final isLogin = state.matchedLocation == Routes.login;

    //   // if (isRegister) return Routes.registerWithLeading;
    //   // if (isResetPassword) return Routes.resetPassword;
    //   // if (isRPasswordOtp) return Routes.resetPwdOtp;
    //   // if (isResetSuccess) return Routes.resetPwdSuccess;
    //   // if (isVerification) return Routes.emailVerification;

    //   // if (onboardingCubit.state == OnboardingState.notCompleted) {
    //   //   if (isLogin) return Routes.loginWithLeading;
    //   //   return null;
    //   // } else {
    //   //   if (isPartiallyAuth) return Routes.partialLogin;
    //   //   if (isUnAuth) return Routes.login;
    //   //   return null;
    //   // }
    //   // switch (authBloc.state.status) {
    //   //   case AuthStatus.partiallyAuthenticated:
    //   //     return Routes.partialLogin;
    //   //   case AuthStatus.unauthenticated:
    //   //     return Routes.login;
    //   //   case AuthStatus.authenticated:
    //   //   default:
    //   //     return null;
    //   // }
    // },
    routes: [
      GoRoute(
        path: MRoutes.startup,
        name: MRoutes.startup,
        builder: (context, gState) => const StartupPage(),
      ),
      GoRoute(
        path: MRoutes.onboarding,
        name: MRoutes.onboarding,
        builder: (context, gState) => const OnboardingPage(),
      ),
      GoRoute(
        path: MRoutes.createBroadcast,
        name: MRoutes.createBroadcast,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateBroadcastPage(),
      ),
      GoRoute(
        path: MRoutes.broadcast,
        name: MRoutes.broadcast,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BroadcastPage(),
      ),
      GoRoute(
        path: MRoutes.login,
        name: MRoutes.login,
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
        path: MRoutes.register,
        name: MRoutes.register,
        builder: (context, state) {
          final implyLeading = state.uri.queryParameters['implyLeading'];

          return RegisterPage(
            implyLeading: implyLeading == 'true' ? true : false,
          );
        },
      ),
      GoRoute(
        path: MRoutes.resetPassword,
        name: MRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: MRoutes.resetPwdOtp,
        name: MRoutes.resetPwdOtp,
        builder: (context, state) => const ResetPasswordOtpVerificationPage(),
      ),
      GoRoute(
        path: MRoutes.resetPwdSuccess,
        name: MRoutes.resetPwdSuccess,
        builder: (context, state) => const ResetPasswordSuccessPage(),
      ),
      GoRoute(
        path: MRoutes.createNewPassword,
        name: MRoutes.createNewPassword,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateNewPasswordPage(),
      ),
      GoRoute(
        path: MRoutes.emailVerification,
        name: MRoutes.emailVerification,
        builder: (context, state) => const EmailVerificationPage(),
      ),
      GoRoute(
        path: MRoutes.stream,
        name: MRoutes.stream,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StreamPage(),
      ),
      GoRoute(
        path: MRoutes.recentlyLive,
        name: MRoutes.recentlyLive,
        builder: (context, state) => const RecentlyLivePage(),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: MRoutes.details,
        name: MRoutes.details,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final broadcast = (state.extra) as Broadcast;
          return DetailsPage(broadcast: broadcast);
        },
      ),
      GoRoute(
        path: MRoutes.notifications,
        name: MRoutes.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: MRoutes.chat,
        name: MRoutes.chat,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChatPage(),
      ),
      GoRoute(
        path: MRoutes.bible,
        name: MRoutes.bible,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BiblePage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MLayout(shell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: MRoutes.home,
                name: MRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: MRoutes.discover,
                name: MRoutes.discover,
                builder: (context, state) => const DiscoverPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: MRoutes.notes,
                name: MRoutes.notes,
                builder: (context, state) => const NotesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: MRoutes.profile,
                name: MRoutes.profile,
                builder: (context, state) => ProfilePage(
                  id: state.extra as String?,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

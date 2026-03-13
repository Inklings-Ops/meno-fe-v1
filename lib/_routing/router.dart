import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/discover/pages/discover_page.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno/features/onboarding/onboarding.dart';
import 'package:meno/features/profile/pages/_pages.dart';

final class MenoRouter {
  MenoRouter({required AuthManager auth, required OnboardingManager onboarding})
    : _auth = auth,
      _onboarding = onboarding;

  final AuthManager _auth;
  final OnboardingManager _onboarding;

  late final GoRouter routerConfig = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: R.home,
    redirect: (context, state) {
      final nextRoute = state.matchedLocation;
      final isPublicRoute = R.publicRoutes.contains(nextRoute);

      final isAuthenticated = _auth.activeUserId.value.isValid;
      final isPendingVerification = _auth.pendingEmailVerification.value;

      final isOnboarded = _onboarding.isOnboarded.value;

      if (!isOnboarded) {
        if (!isPublicRoute) return R.onboarding;
        return null;
      }

      if (isAuthenticated && isPendingVerification) {
        if (nextRoute == R.emailVerification) return null;
        return R.emailVerification;
      }

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
    refreshListenable: Listenable.merge([
      _auth.activeUserId,
      _auth.pendingEmailVerification,
      _onboarding.isOnboarded,
    ]),
    routes: [
      /**
       *  Loading Page
       */
      GoRoute(
        path: R.loading,
        builder: (context, state) => const LoadingPage(),
      ),

      /**
       *  Onboarding
       */
      GoRoute(
        path: R.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      /**
       *  Authentication
       */
      GoRoute(
        path: R.login,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          final implyLeading = bool.parse(params['implyLeading'] ?? 'false');
          return LoginPage(implyLeading: implyLeading);
        },
      ),

      GoRoute(
        path: R.register,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          final implyLeading = bool.parse(params['implyLeading'] ?? 'false');
          return RegisterPage(implyLeading: implyLeading);
        },
      ),

      GoRoute(
        path: R.emailVerification,
        builder: (context, state) => const EmailVerificationPage(),
      ),

      GoRoute(
        path: R.resetPassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),

      GoRoute(
        path: R.resetPwdOtp,
        builder: (context, state) => const ResetPasswordOtpVerificationPage(),
      ),

      GoRoute(
        path: R.resetPwdSuccess,
        builder: (context, state) => const ResetPasswordSuccessPage(),
      ),

      GoRoute(
        path: '/switch-account/:id',
        builder: (context, state) {
          final userId = state.pathParameters['id'] ?? '';
          return SwitchAccountPage(userIdStr: userId);
        },
      ),

      /**
       *  Broadcasts
       */
      GoRoute(
        path: R.broadcastEditor,
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const BroadcastEditorPage(),
            transitionDuration: const Duration(milliseconds: 310),
            reverseTransitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCirc,
                reverseCurve: Curves.easeInCubic,
              );

              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: .zero,
                ).animate(curved),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(curved),
                  child: child,
                ),
              );
            },
          );
        },
      ),

      GoRoute(
        path: R.liveSessionInitialization,
        builder: (context, state) => const LiveSessionInitPage(),
      ),

      /**
       *  Main Navigation Shell
       *  ------------------------------------------------------------------
       *  Contains the Home, Discover, Create Broadcast, Notes & Profile
       *  pages
       */
      StatefulShellRoute(
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: LiveSessionShell.builder,
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: R.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: R.discover,
                builder: (context, state) => const DiscoverPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              /// Notes Page Shell Route
              StatefulShellRoute(
                builder: (context, state, navigationShell) => navigationShell,
                navigatorContainerBuilder: NotesLayoutWidget.builder,
                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: R.noteSection,
                        builder: (context, state) => const NoteListWidget(),
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: R.folderSection,
                        builder: (context, state) => const FolderListWidget(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: R.myProfile,
                builder: (context, state) => const MyProfilePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: R.webCreateBroadcast,
                builder: (context, state) => const BroadcastEditorPage(),
              ),
            ],
          ),
        ],
      ),
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

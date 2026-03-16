import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/discover/pages/discover_search_page.dart';
import 'package:meno/features/discover/pages/discover_shell.dart';
import 'package:meno/features/discover/widgets/_widgets.dart';
import 'package:meno/features/notes/notes.dart';
import 'package:meno/features/onboarding/onboarding.dart';
import 'package:meno/features/profile/pages/_pages.dart';
import 'package:meno/features/settings/pages/_pages.dart';

class MenoRouter {
  /// Factory that wires up the refresh listenable from the DI graph.
  /// Call this only after BOTH the 'auth' scope and the 'onboarded' scope
  /// have been pushed (i.e. after `allReady()` in your splash screen).
  factory MenoRouter.create() {
    final refreshListenable = Listenable.merge([
      di<OnboardingManager>().isOnboarded,
      di<AuthManager>().activeUserId,
      di<AuthManager>().emailVerified,
    ]);
    return MenoRouter._(refreshListenable);
  }

  MenoRouter._(Listenable refreshListenable)
    : config = _buildRouter(refreshListenable);

  final GoRouter config;

  // Expose so GoRoutes can reference it via parentNavigatorKey.
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter _buildRouter(Listenable refreshListenable) {
    return GoRouter(
      debugLogDiagnostics: true,
      refreshListenable: refreshListenable,
      navigatorKey: rootNavigatorKey,
      initialLocation: R.home,
      redirect: _redirect,
      routes: [
        GoRoute(
          path: R.loading,
          builder: (context, state) => const LoadingPage(),
        ),
        GoRoute(
          path: R.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
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
          path: R.settings,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: R.notificationSettings,
          builder: (context, state) => const NotificationsSettingsPage(),
        ),
        GoRoute(
          path: R.securitySettings,
          builder: (context, state) => const SecuritySettingsPage(),
        ),
        GoRoute(
          path: R.notificationSettings,
          builder: (context, state) => const NotificationsSettingsPage(),
        ),
        GoRoute(path: R.about, builder: (context, state) => const AboutPage()),
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
          path: R.broadcasts,
          name: R.broadcasts,
          builder: (context, state) {
            final queryParameters = state.uri.queryParameters;
            return BroadcastsPage(queryParameters: queryParameters);
          },
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final broadcastIdStr = state.pathParameters['id'] ?? '';
                return BroadcastDetailsPage(broadcastIdStr: broadcastIdStr);
              },
            ),
          ],
        ),
        GoRoute(
          path: R.endedBroadcast,
          builder: (context, state) => const EndedBroadcastPage(),
        ),
        GoRoute(
          path: R.liveSessionInitialization,
          builder: (context, state) => const LiveSessionInitPage(),
        ),
        GoRoute(
          path: R.discoverSearch,
          builder: (context, state) => const DiscoverSearchPage(),
        ),
        GoRoute(
          path: '/users/:userId/profile',
          builder: (context, state) {
            final params = state.pathParameters;
            return UserProfilePage(userIdStr: params['userId']!);
          },
        ),

        /**
         *  Main Navigation Shell
         *  ------------------------------------------------------------------
         *  Contains the Home, Discover, Create Broadcast, Notes & Profile
         *  pages
         */
        StatefulShellRoute.indexedStack(
          builder: RootShell.builder,
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
                StatefulShellRoute(
                  builder: (context, state, navigationShell) => navigationShell,
                  navigatorContainerBuilder: DiscoverShell.builder,
                  branches: [
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: R.discoverAllTab,
                          builder: (context, state) {
                            return const AllBroadcastsWidget();
                          },
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: R.discoverNowLiveTab,
                          builder: (context, state) {
                            return const NowLiveBroadcastsWidget();
                          },
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: R.discoverRecentlyLiveTab,
                          builder: (_, state) {
                            return const RecentlyLiveBroadcastsWidget();
                          },
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: R.discoverSuggestedAccountsLiveTab,
                          builder: (_, state) {
                            return const SuggestedAccountsWidget();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                StatefulShellRoute(
                  builder: (context, state, navigationShell) => navigationShell,
                  navigatorContainerBuilder: NotesFoldersShell.builder,
                  branches: [
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: R.notes,
                          builder: (context, state) => const NoteListWidget(),
                          routes: [
                            GoRoute(
                              path: ':id',
                              parentNavigatorKey: MenoRouter.rootNavigatorKey,
                              builder: (context, state) {
                                final rawId = state.pathParameters['id'];
                                final noteId = (rawId == null || rawId == 'new')
                                    ? null
                                    : rawId;
                                return NoteEditorPage(noteId: noteId);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: R.folders,
                          builder: (context, state) => const FolderListWidget(),
                          routes: [
                            GoRoute(
                              name: R.folderName,
                              path: ':id',
                              parentNavigatorKey: MenoRouter.rootNavigatorKey,
                              builder: (context, state) => FolderPage(
                                folderId: state.pathParameters['id'] ?? '',
                              ),
                            ),
                          ],
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
          ],
        ),
      ],
    );
  }

  static String? _redirect(BuildContext context, GoRouterState state) {
    final nextRoute = state.matchedLocation;
    final isPublicRoute = R.publicRoutes.contains(nextRoute);

    // Read current values directly from managers.
    // These are cheap synchronous reads — no awaiting needed.
    final authManager = di<AuthManager>();
    final onboardingManager = di<OnboardingManager>();

    final userId = authManager.activeUserId.value;

    final isAuthenticated = userId.isValid;
    final isEmailVerified = authManager.emailVerified.value;
    final isOnboarded = onboardingManager.isOnboarded.value;

    if (!isOnboarded) {
      if (!isPublicRoute) return R.onboarding;
      return null;
    }

    if (!isAuthenticated) {
      if (!isPublicRoute) {
        if (nextRoute.contains('switch-account')) return null;
        return R.login;
      }
      return null;
    }

    if (isAuthenticated && !isEmailVerified) {
      if (nextRoute == R.emailVerification) return null;
      return R.emailVerification;
    }

    if (isPublicRoute) return R.home;
    return null;
  }
}

extension MenoRouterExtensions on BuildContext {
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

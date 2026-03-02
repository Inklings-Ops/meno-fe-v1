import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/bible/bible.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/chat/chat.dart';
import 'package:meno/features/discover/discover.dart';
import 'package:meno/features/notes/notes.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/features/settings/settings.dart';
import 'package:meno/shared/shared.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final class MenoRouter {
  MenoRouter(this._repository);

  final IAuthRepository _repository;

  // late final rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter routerConfig = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: R.home,
    // navigatorKey: rootNavigatorKey,
    redirect: (context, state) {
      final nextRoute = state.matchedLocation;
      final isPublicRoute = R.publicRoutes.contains(nextRoute);
      final isAuthenticated = _repository.activeUserId.value.isSome();

      if (!isAuthenticated) {
        if (!isPublicRoute) {
          if (nextRoute.contains('switch-account')) return null;
          return R.login;
        }
        return null;
      }

      // final isEmailVerified = _repository.isEmailVerified;
      // if (!isEmailVerified) {
      //   if (!isPublicRoute) return R.emailVerification;
      //   return null;
      // }

      if (isPublicRoute) return R.home;
      return null;
    },
    refreshListenable: di<AuthManager>().userId,
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
      GoRoute(path: R.about, builder: (context, state) => const AboutPage()),

      GoRoute(
        path: R.notificationSettings,
        builder: (context, state) => const NotificationsSettingsPage(),
      ),

      GoRoute(
        path: R.createBroadcast,
        builder: (context, state) => const CreateBroadcastPage(),
      ),

      GoRoute(
        path: R.broadcasts,
        name: R.broadcasts,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          final query = BroadcastQuery.fromRouter(params);
          return BroadcastsPage(query: query);
        },
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return BroadcastDetailsPage(id: id);
            },
          ),
        ],
      ),

      GoRoute(
        path: '/users/:userId/profile',
        builder: (context, state) {
          final params = state.pathParameters;
          return ProfilePage(userIdStr: params['userId']!);
        },
      ),

      GoRoute(
        path: R.endedBroadcast,
        builder: (context, state) => const EndedBroadcastPage(),
      ),

      GoRoute(
        name: R.noteEditorName,
        path: '/note-editor/:noteId',
        builder: (context, state) {
          final rawId = state.pathParameters['noteId'];
          final noteId = (rawId == null || rawId == 'new') ? null : rawId;
          return NoteEditorPage(noteId: noteId);
        },
      ),

      GoRoute(
        name: R.folderName,
        path: '/folders/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return FolderPage(id: id);
        },
      ),

      // ######################################################################
      // LIVE BROADCAST TAB SHELL
      // ######################################################################
      GoRoute(
        path: R.liveSessionInitialization,
        builder: (context, state) => const LiveSessionInitializationPage(),
      ),

      StatefulShellRoute(
        // parentNavigatorKey: rootNavigatorKey,
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, navigationShell, children) {
          return LiveLayoutWidget(
            navigationShell: navigationShell,
            children: children,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: R.broadcastTab,
                builder: (context, state) {
                  // if (state.extra == null) return const LiveBroadcastTab();
                  // return const LiveStreamTab();
                  return const LiveBroadcastTab();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: R.chatTab,
                builder: (context, state) => const LiveChatTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: R.bibleTab,
                builder: (context, state) => const LiveBibleTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: R.notesTab,
                builder: (context, state) => const LiveNotesTab(),
                // routes: [
                //   GoRoute(
                //     parentNavigatorKey: notesTabKey,
                //     path: R.notesTabEditor,
                //     builder: (context, state) {
                //       final note = state.extra as Note? ?? Note.empty;
                //       return NoteEditorPage(note: note);
                //     },
                //   ),
                // ],
              ),
            ],
          ),
        ],
      ),

      // ######################################################################
      // MAIN APP NAVIGATION SHELL
      // ######################################################################
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MenoLayout(shell: navigationShell, currentRoute: state.path),
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
                navigatorContainerBuilder: (_, navigationShell, children) {
                  return NotesLayoutWidget(
                    navigationShell: navigationShell,
                    children: children,
                  );
                },
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
                builder: (context, state) => const CreateBroadcastPage(),
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

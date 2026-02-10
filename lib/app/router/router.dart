import 'package:flutter/material.dart'
    show GlobalKey, NavigatorState, ScaffoldMessengerState;
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/auth/application/auth_manager.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/auth/presentation/presentation.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/features/discover/presentation/presentation.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno/features/profile/presentation/presentation.dart';
import 'package:meno/shared/domain/broadcast_query.dart';
import 'package:meno/shared/presentation/layout/meno_layout.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final rootNavigatorKey = GlobalKey<NavigatorState>();
final mainLayoutKey = GlobalKey<NavigatorState>();
final broadcastLayoutKey = GlobalKey<NavigatorState>();

final broadcastTabKey = GlobalKey<NavigatorState>();
final streamTabKey = GlobalKey<NavigatorState>();
final chatTabKey = GlobalKey<NavigatorState>();
final bibleTabKey = GlobalKey<NavigatorState>();
final notesTabKey = GlobalKey<NavigatorState>();

final dashboardKey = GlobalKey<NavigatorState>();
final discoverKey = GlobalKey<NavigatorState>();
final notesKey = GlobalKey<NavigatorState>();
final profileKey = GlobalKey<NavigatorState>();

final notesLayoutKey = GlobalKey<NavigatorState>();
final noteSectionKey = GlobalKey<NavigatorState>();
final folderSectionKey = GlobalKey<NavigatorState>();

final class MenoRouter {
  MenoRouter(this._repository);

  final IAuthRepository _repository;

  late final GoRouter routerConfig = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: R.home,
    navigatorKey: rootNavigatorKey,
    redirect: (context, state) {
      final nextRoute = state.matchedLocation;
      final isPublicRoute = R.publicRoutes.contains(nextRoute);
      final isAuthenticated = _repository.activeUserId.value.isSome();

      if (!isAuthenticated) {
        if (!isPublicRoute) return R.login;
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
      GoRoute(path: R.login, builder: (_, _) => const LoginPage()),

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
      ),

      /// Main Shell Route
      /// Houses the main [MenoLayout] with the apps bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MenoLayout(
          key: mainLayoutKey,
          shell: navigationShell,
          currentRoute: state.path,
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: dashboardKey,
            routes: [
              GoRoute(
                path: R.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: discoverKey,
            routes: [
              GoRoute(
                path: R.discover,
                builder: (context, state) => const DiscoverPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: notesKey,
            routes: [
              /// Notes Page Shell Route
              StatefulShellRoute(
                builder: (context, state, navigationShell) => navigationShell,
                navigatorContainerBuilder: (_, navigationShell, children) {
                  return NotesPageLayout(
                    key: notesLayoutKey,
                    navigationShell: navigationShell,
                    children: children,
                  );
                },
                branches: [
                  StatefulShellBranch(
                    navigatorKey: noteSectionKey,
                    routes: [
                      GoRoute(
                        path: R.noteSection,
                        builder: (context, state) => const NoteListWidget(),
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    navigatorKey: folderSectionKey,
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
            navigatorKey: profileKey,
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

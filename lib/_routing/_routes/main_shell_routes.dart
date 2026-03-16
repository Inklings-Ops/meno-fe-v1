import 'package:go_router/go_router.dart';
import 'package:meno/_routing/router_keys.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/_shared/pages/_layouts/root_shell.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/discover/pages/discover_shell.dart';
import 'package:meno/features/discover/widgets/_widgets.dart';
import 'package:meno/features/notes/notes.dart';
import 'package:meno/features/profile/pages/_pages.dart';

/// The main bottom-navigation shell — Home, Discover, Notes, Profile.
///
/// NOTE ON NESTING: The Discover branch uses a nested [StatefulShellRoute]
/// for its sub-tabs (All, Now Live, Recently Live, Suggested). This is the
/// ONLY nested shell in the app. Nesting is acceptable here because the
/// Discover shell has a flat, fixed tab set with no further nesting, meaning
/// the navigator depth stays bounded. See [_discoverBranch] for details.
final class MainShellRoutes {
  const MainShellRoutes._();

  /// Main Root Shell
  static StatefulShellRoute get shell => StatefulShellRoute.indexedStack(
    builder: RootShell.builder,
    parentNavigatorKey: RouterKeys.root,
    branches: [_homeBranch, _discoverBranch, _notesBranch, _profileBranch],
  );

  /// Home Branch
  static StatefulShellBranch get _homeBranch => StatefulShellBranch(
    navigatorKey: RouterKeys.home,
    routes: [GoRoute(path: R.home, builder: (_, __) => const HomePage())],
  );

  /// Discover Branch
  static StatefulShellBranch get _discoverBranch => StatefulShellBranch(
    navigatorKey: RouterKeys.discover,
    routes: [
      StatefulShellRoute(
        builder: (_, __, shell) => shell,
        navigatorContainerBuilder: DiscoverShell.builder,
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: R.discoverAllTab,
                builder: (_, __) => const AllBroadcastsWidget(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: R.discoverNowLiveTab,
                builder: (_, __) => const NowLiveBroadcastsWidget(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: R.discoverRecentlyLiveTab,
                builder: (_, __) => const RecentlyLiveBroadcastsWidget(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: R.discoverSuggestedAccountsLiveTab,
                builder: (_, __) => const SuggestedAccountsWidget(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  /// Notes Branch
  static StatefulShellBranch get _notesBranch => StatefulShellBranch(
    navigatorKey: RouterKeys.notes,
    routes: [GoRoute(path: R.notes, builder: (_, __) => const MyNotesPage())],
  );

  /// My Profile Branch
  static StatefulShellBranch get _profileBranch => StatefulShellBranch(
    navigatorKey: RouterKeys.profile,
    routes: [
      GoRoute(path: R.myProfile, builder: (_, __) => const MyProfilePage()),
    ],
  );
}

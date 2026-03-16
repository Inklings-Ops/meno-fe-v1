import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/discover/pages/discover_search_page.dart';
import 'package:meno/features/notes/notes.dart';
import 'package:meno/features/onboarding/pages/onboarding_page.dart';
import 'package:meno/features/profile/pages/_pages.dart';

/// Routes that live outside any shell — they push over the entire screen
/// using the root navigator.
final class StandaloneRoutes {
  const StandaloneRoutes._();

  static List<RouteBase> get routes => [
    GoRoute(path: R.loading, builder: (_, __) => const LoadingPage()),
    GoRoute(path: R.onboarding, builder: (_, __) => const OnboardingPage()),
    GoRoute(
      path: R.discoverSearch,
      builder: (_, __) => const DiscoverSearchPage(),
    ),
    GoRoute(
      path: R.endedBroadcast,
      builder: (_, __) => const EndedBroadcastPage(),
    ),
    GoRoute(
      path: R.liveSessionInitialization,
      builder: (_, __) => const LiveSessionInitPage(),
    ),
    GoRoute(
      path: '/users/:userId/profile',
      builder: (_, state) {
        final userIdStr = state.pathParameters['userId']!;
        return UserProfilePage(userIdStr: userIdStr);
      },
    ),
    GoRoute(
      path: '/notes/:id',
      builder: (_, state) {
        final raw = state.pathParameters['id'];
        final noteIdStr = (raw == null || raw == 'new') ? null : raw;
        return NoteEditorPage(noteIdStr: noteIdStr);
      },
    ),
    GoRoute(
      path: '/folders/:id',
      builder: (_, state) {
        final folderIdStr = state.pathParameters['id'] ?? '';
        return FolderPage(folderIdStr: folderIdStr);
      },
    ),
    GoRoute(
      path: R.broadcastEditor,
      pageBuilder: (_, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const BroadcastEditorPage(),
        transitionDuration: const Duration(milliseconds: 310),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCirc,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(curved),
              child: child,
            ),
          );
        },
      ),
    ),
    GoRoute(
      path: R.broadcasts,
      name: R.broadcasts,
      builder: (_, state) {
        final queryParameters = state.uri.queryParameters;
        return BroadcastsPage(queryParameters: queryParameters);
      },
      routes: [
        GoRoute(
          path: ':id',
          builder: (_, state) {
            final broadcastIdStr = state.pathParameters['id'] ?? '';
            return BroadcastDetailsPage(broadcastIdStr: broadcastIdStr);
          },
        ),
      ],
    ),
  ];
}

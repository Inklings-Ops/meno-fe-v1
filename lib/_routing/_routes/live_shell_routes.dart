import 'package:go_router/go_router.dart';
import 'package:meno/_routing/router_keys.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/bible/widgets/live_bible_tab.dart';
import 'package:meno/features/broadcast/widgets/_widgets.dart';
import 'package:meno/features/chat/widgets/live_chat_tab.dart';
import 'package:meno/features/notes/notes.dart';

/// The live session shell — four branches for Broadcast, Chat, Bible, Notes.
///
/// Returns a single [StatefulShellRoute] to be included in the root routes
/// list. All branches share the [LiveSessionShell] UI container.
final class LiveShellRoutes {
  const LiveShellRoutes._();

  static StatefulShellRoute get shell => StatefulShellRoute(
    parentNavigatorKey: RouterKeys.root,
    builder: (context, state, navigationShell) => navigationShell,
    navigatorContainerBuilder: LiveSessionShell.builder,
    branches: [
      StatefulShellBranch(
        navigatorKey: RouterKeys.liveBroadcast,
        routes: [
          GoRoute(
            path: R.liveBroadcast,
            builder: (context, state) => const LiveBroadcastTab(),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: RouterKeys.liveChat,
        routes: [
          GoRoute(
            path: R.liveChat,
            builder: (context, state) => const LiveChatTab(),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: RouterKeys.liveBible,
        routes: [
          GoRoute(
            path: R.liveBible,
            builder: (context, state) => const LiveBibleTab(),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: RouterKeys.liveNotes,
        routes: [
          GoRoute(
            path: R.liveNotes,
            builder: (context, state) => const MyNotesPage.live(),
            routes: [
              GoRoute(
                path: '${R.liveNotes}/:id',
                builder: (_, state) {
                  final raw = state.pathParameters['id'];
                  final noteIdStr = (raw == null || raw == 'new') ? null : raw;
                  return NoteEditorPage(noteIdStr: noteIdStr);
                },
              ),
              GoRoute(
                path: '${R.liveFolders}/:id',
                builder: (_, state) {
                  final folderIdStr = state.pathParameters['id'] ?? '';
                  return FolderPage(folderIdStr: folderIdStr);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

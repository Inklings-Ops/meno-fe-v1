import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../application/broadcast/broadcast_notifier.dart';
import '../../widgets/chat_tab.dart';
import '../../widgets/live_bible_tab.dart';
import '../../widgets/live_scaffold.dart';
import '../../widgets/notes_tab.dart';
import 'broadcast_ended_modal.dart';
import 'broadcast_tab.dart';

class BroadcastPage extends HookConsumerWidget {
  const BroadcastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenManual(broadcastNotifierProvider, (previous, next) {
      next.onStarted.fold(
        () => null,
        (either) => either.fold(
          (l) => context.showBroadcastError(l),
          (r) => null,
        ),
      );

      next.onDeleted.fold(
        () => null,
        (either) => either.fold(
          (l) => context.showBroadcastError(l),
          (r) => context.go(Routes.home),
        ),
      );

      next.onEnded.map(
        (a) {
          context.showModal(
            const BroadcastEndedModal(),
            enableDrag: false,
            useRootNavigator: true,
            isDismissible: false,
            isScrollControlled: true,
          );
        },
      );
    });


    return const PopScope(
      canPop: false,
      child: LiveStreamScaffold(
        tabs: [
          Tab(text: "Broadcast"),
          Tab(text: "Chats"),
          Tab(text: "Live Bible"),
          Tab(text: "Notes"),
        ],
        tabViews: [
          BroadcastTab(),
          ChatTab(),
          LiveBibleTab(),
          NotesTab(),
        ],
      ),
    );
  }
}

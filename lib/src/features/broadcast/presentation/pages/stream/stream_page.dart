import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../application/stream/stream_notifier.dart';
import '../../widgets/chat_tab.dart';
import '../../widgets/live_bible_tab.dart';
import '../../widgets/live_scaffold.dart';
import '../../widgets/notes_tab.dart';
import 'stream_tab.dart';

class StreamPage extends ConsumerWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(streamNotifierProvider, (previous, next) {
      next.onLeave.fold(
        () => null,
        (either) => either.fold(
          (l) => context.showBroadcastError(l),
          (r) => null,
        ),
      );
    });


    return const LiveStreamScaffold(
      tabs: [
        Tab(text: "Broadcast"),
        Tab(text: "Chats"),
        Tab(text: "Live Bible"),
        Tab(text: "Notes"),
      ],
      tabViews: [
        StreamTab(),
        ChatTab(),
        LiveBibleTab(),
        NotesTab(),
      ],
    );
  }
}

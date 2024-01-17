import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/src/core/broadcast/meno_event_provider.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import '../../widgets/chat_tab.dart';
import '../../widgets/live_bible_tab.dart';
import '../../widgets/live_scaffold.dart';
import '../../widgets/notes_tab.dart';
import 'stream_tab.dart';

class StreamPage extends ConsumerStatefulWidget {
  const StreamPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StreamPageState();
}

class _StreamPageState extends ConsumerState<StreamPage> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(eventProvider, (previous, next) {
      next.event.whenOrNull(endedBroadcast: (_) => context.go(Routes.home));
    });

    // final listener = ref.read(liveKitNotifierProvider.notifier).listener;
    // listener?.on((p0) => Logger().f('FROM NEW LISTENER=$p0'));
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(liveKitNotifierProvider).when(
    //       data: (data) {
    //         final listener = data.createListener();
    //         listener.listen((p0) => Logger().w(p0));
    //         listener.on((p0) => Logger().f(p0));
    //       },
    //       error: (err, stack) => Logger().e(err),
    //       loading: () => null,
    //     );

    return const LiveStreamScaffold(
      tabs: [
        Tab(text: 'Broadcast'),
        Tab(text: 'Chats'),
        Tab(text: 'Live Bible'),
        Tab(text: 'Notes'),
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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast/broadcast_notifier.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import 'broadcast_tab.dart';
import 'chat_tab.dart';
import 'live_bible_tab.dart';
import 'notes_tab.dart';

@RoutePage()
class BroadcastPage extends StatefulHookConsumerWidget {
  const BroadcastPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends ConsumerState<BroadcastPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

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
          (r) => context.router.replaceAll([const MLayoutRoute()]),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TabController tabController = useTabController(initialLength: 4);

    return MScaffold(
      padding: EdgeInsets.zero,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Padding(
          padding: MediaQuery.viewPaddingOf(context),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            constraints: const BoxConstraints(maxHeight: 32),
            child: TabBar(
              tabs: const [
                Tab(text: "Broadcast"),
                Tab(text: "Chats"),
                Tab(text: "Live Bible"),
                Tab(text: "Notes"),
              ],
              controller: tabController,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          BroadcastTab(),
          ChatTab(),
          LiveBibleTab(),
          NotesTab(),
        ],
      ),
    );
  }

  @override
  // TODO: Should keep alive if broadcast is on
  bool get wantKeepAlive => true;
}

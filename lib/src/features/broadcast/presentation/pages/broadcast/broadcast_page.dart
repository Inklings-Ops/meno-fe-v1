import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/live_participants/live_participants_bloc.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../../chat/presentation/widgets/chat_input_container.dart';
import '../../../../chat/presentation/widgets/chat_list.dart';
import '../../../application/broadcast/broadcast_bloc.dart';
import '../../widgets/live_bible_tab.dart';
import '../../widgets/live_scaffold.dart';
import '../../widgets/notes_tab.dart';
import 'broadcast_ended_modal.dart';
import 'broadcast_tab.dart';

class BroadcastPage extends StatelessWidget {
  const BroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BroadcastBloc, BroadcastState>(
      bloc: context.read<BroadcastBloc>(),
      listenWhen: (p, c) =>
          p.onStarted != c.onStarted ||
          p.onEnded != c.onEnded ||
          p.onDeleted != c.onDeleted,
      listener: (context, state) {
        state.onStarted.fold(
          () => null,
          (either) => either.fold(
            (l) => context.showBroadcastError(l),
            (r) {
              context.read<LiveParticipantsBloc>().add(FetchParticipants(r.id));
            },
          ),
        );

        state.onEnded.fold(
          () => null,
          (_) => context.showModal(
            const BroadcastEndedModal(),
            enableDrag: false,
            useRootNavigator: true,
            isDismissible: false,
            isScrollControlled: true,
          ),
        );

        state.onDeleted.fold(
          () => null,
          (either) => either.fold(
            (l) => context.showBroadcastError(l),
            (r) => context.go(Routes.home),
          ),
        );
      },
      child: const PopScope(
        canPop: false,
        child: LiveStreamScaffold(
          tabs: [
            Tab(text: 'Broadcast'),
            Tab(text: 'Chats'),
            Tab(text: 'Live Bible'),
            Tab(text: 'Notes'),
          ],
          tabViews: [
            BroadcastTab(),
            _ChatTab(),
            LiveBibleTab(),
            NotesTab(),
          ],
        ),
      ),
    );
  }
}

class _ChatTab extends HookWidget {
  const _ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return BlocBuilder<BroadcastBloc, BroadcastState>(
      builder: (context, state) => LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ChatList(
                  broadcastId: state.broadcast.id,
                  controller: scrollController,
                ),
              ),
            ),
            SizedBox(
              height: 52.h,
              width: constraints.maxWidth,
              child: ChatInputContainer(
                broadcastId: state.broadcast.id,
                scrollController: scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

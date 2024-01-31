import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_fe_v1/src/router/router.dart';

import '../../../../../services/meno/meno_bloc.dart';
import '../../../application/stream/stream_bloc.dart';
import '../../widgets/chat_tab.dart';
import '../../widgets/live_bible_tab.dart';
import '../../widgets/live_scaffold.dart';
import '../../widgets/notes_tab.dart';
import 'stream_tab.dart';

class StreamPage extends StatelessWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StreamBloc, StreamState>(
          listenWhen: (p, c) => p.onLeave != c.onLeave,
          listener: (context, state) {
            state.onLeave.fold(
              () => null,
              (_) => context.go(Routes.home),
            );
          },
        ),
        BlocListener<MenoBloc, MenoState>(
          listener: (context, state) {
            state.whenOrNull(
              endedBroadcast: () {
                context.go(Routes.home);
                context.read<StreamBloc>().close();
              },
            );
          },
        ),
      ],
      child: const LiveStreamScaffold(
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
      ),
    );
  }
}

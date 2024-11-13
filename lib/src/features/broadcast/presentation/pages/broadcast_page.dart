import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/live_kit/bloc/live_kit_bloc.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';

class BroadcastPage extends StatelessWidget {
  const BroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcastId = context.read<BroadcastBloc>().state.broadcast.id;

    final participantsBloc = context.read<ParticipantsBloc>();
    final socket = context.watch<SocketBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<LiveKitBloc, LiveKitState>(
          listener: (context, state) {
            state.whenOrNull(
              connectionFailed: (error) {
                context.read<LiveBloc>().add(const GoFailure());
                context.showErrorSnackBar(error);
              },
              broadcastConnected: (room, microphoneEnabled) {
                socket.add(SocketStartBroadcast(broadcastId));
              },
            );
          },
        ),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (error) {
                context.read<LiveBloc>().add(const GoFailure());
                context.showErrorSnackBar(error);
              },
              broadcastStarted: () {
                socket.add(SocketGetMessages(broadcastId));
                participantsBloc.add(GetLiveParticipants(broadcastId));
                context.read<TimerCubit>().start();
                context.read<LiveBloc>().add(const LiveStarted());
                context.read<LiveBloc>().add(const GoLive());
              },
              broadcastEnded: () {
                participantsBloc.add(GetAllParticipants(broadcastId));
                context.read<TimerCubit>().stop();
                context.read<LiveBloc>().add(const LiveReset());
                router.replace<void>(Routes.endedBroadcast);
              },
              messagesReceived: (chats) {
                context.read<ChatBloc>().add(LoadChatMessages(chats));
              },
            );
          },
        ),
      ],
      child: const LiveScaffold(
        tabs: [
          Tab(text: 'Broadcast'),
          Tab(text: 'Chats'),
          Tab(text: 'Live Bible'),
          Tab(text: 'Notes'),
        ],
        tabViews: [
          BroadcastTab(),
          BroadcastChatTab(),
          LiveBibleTab(),
          NotesTab(),
        ],
      ),
    );
  }
}

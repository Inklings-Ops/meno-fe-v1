import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/live_kit/bloc/live_kit_bloc.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';

class StreamPage extends HookWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socket = context.watch<SocketBloc>();

    final broadcast = useMemoized(
      () => context.read<StreamBloc>().state.broadcast,
    );
    final id = broadcast.id;

    return MultiBlocListener(
      listeners: [
        BlocListener<LiveKitBloc, LiveKitState>(
          listener: (context, state) {
            state.whenOrNull(
              connectionFailed: (error) {
                context.read<LiveBloc>().add(const GoFailure());
                router.pop();
              },
              streamConnected: (_) => socket.add(SocketJoinBroadcast(id)),
            );
          },
        ),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (error) {
                context.read<LiveBloc>().add(const GoFailure());
                context.read<LiveKitBloc>().add(const LiveKitDisconnect());
                router.pop();
              },
              broadcastJoined: () {
                context.read<SocketBloc>().add(SocketGetMessages(id));
                context.read<ParticipantsBloc>().add(GetLiveParticipants(id));
                context.read<TimerCubit>().setAndStart(broadcast.startTime);
                context.read<LiveBloc>().add(const LiveStarted());
                context.read<LiveBloc>().add(const GoStreaming());
              },
              messagesReceived: (chats) {
                context.read<ChatBloc>().add(LoadChatMessages(chats));
              },
              endedBroadcast: (data) {
                context.read<LiveBloc>().add(const LiveReset());
                router.go(Routes.home);
              },
              broadcastLeft: () {
                context.read<LiveBloc>().add(const LiveReset());
                router.go(Routes.home);
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
          StreamTab(),
          StreamChatTab(),
          LiveBibleTab(),
          NotesTab(),
        ],
      ),
    );
  }
}

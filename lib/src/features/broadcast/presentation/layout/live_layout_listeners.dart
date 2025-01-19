import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class LiveLayoutListeners extends StatelessWidget {
  const LiveLayoutListeners({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final chat = context.read<ChatListBloc>();
    final live = context.read<LiveBloc>();
    final livekit = context.read<LiveKitBloc>();
    final participants = context.read<ParticipantsBloc>();
    final socket = context.read<SocketBloc>();
    final timer = context.read<TimerCubit>();
    final background = di<BackgroundService>();

    return MultiBlocListener(
      listeners: [
        BlocListener<LiveKitBloc, LiveKitState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            state.status.whenOrNull(
              failed: (error, isStream) {
                live.add(const GoFailure());
                context.showErrorSnackBar(error);
                if (isStream) return router.pop();
              },
              broadcastConnected: () {
                final broadcast = context.read<BroadcastBloc>().state.broadcast;
                socket.add(SocketStartBroadcast(broadcast.id));
              },
              streamConnected: () {
                final broadcast = context.read<StreamBloc>().state.broadcast;
                socket.add(SocketJoinBroadcast(broadcast.id));
              },
            );
          },
        ),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (error, isStream) {
                live.add(const GoFailure());
                livekit.add(const LiveKitDisconnect());
                context.showErrorSnackBar(error);
                if (isStream) return router.pop();
              },
              broadcastStarted: () async {
                final broadcast = context.read<BroadcastBloc>().state.broadcast;
                chat.add(InitializeChatList(broadcast));
                socket.add(SocketGetMessages(broadcast.id));
                participants.add(GetLiveParticipants(broadcast.id));
                timer.start();
                live.add(const LiveStarted());
                live.add(const GoLive());
                await background.startBroadcastBackgroundProcess(broadcast);
              },
              broadcastEnded: () async {
                final broadcast = context.read<BroadcastBloc>().state.broadcast;
                participants.add(GetAllParticipants(broadcast.id));
                timer.stop();
                live.add(const LiveReset());
                if (router.state!.name == Routes.broadcastTab) {
                  await router.replace<void>(Routes.endedBroadcast);
                } else {
                  await router.push<void>(Routes.endedBroadcast);
                }
              },
              broadcastJoined: () async {
                final broadcast = context.read<StreamBloc>().state.broadcast;
                socket.add(SocketGetMessages(broadcast.id));
                chat.add(InitializeChatList(broadcast));
                participants.add(GetLiveParticipants(broadcast.id));
                timer.setAndStart(broadcast.startTime);
                live.add(const LiveStarted());
                live.add(const GoStreaming());
                await background.startBroadcastBackgroundProcess(broadcast);
              },
              broadcastLeft: () async {
                live.add(const LiveReset());
                participants.add(const ParticipantsReset());
                chat.add(const ChatReset());
                context.read<StreamBloc>().add(const StreamReset());
                await timer.dispose();
                router.go(Routes.home);
              },
              endedBroadcast: (data) async {
                if (live.state is Live) return;
                live.add(const LiveReset());
                livekit.add(const LiveKitDisconnect());
                participants.add(const ParticipantsReset());
                chat.add(const ChatReset());
                context.read<StreamBloc>().add(const StreamReset());
                context.showErrorSnackBar(data.reason.message);
                router.go(Routes.home);
                await timer.dispose();
              },
              messagesReceived: (chats) {
                chat.add(LoadChatMessages(chats));
              },
            );
          },
        ),
      ],
      child: child,
    );
  }
}

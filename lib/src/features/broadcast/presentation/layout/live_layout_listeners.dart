import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class LiveLayoutListeners extends HookWidget {
  const LiveLayoutListeners({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatListBloc>();
    final live = context.watch<LiveBloc>();
    final livekit = context.watch<LiveKitBloc>();
    final participants = context.watch<ParticipantsBloc>();
    final socket = context.watch<SocketBloc>();
    final timer = context.watch<TimerCubit>();

    final broadcastBloc = context.watch<BroadcastBloc>();
    final streamBloc = context.watch<StreamBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<LiveKitBloc, LiveKitState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            state.status.whenOrNull(
              failed: (error, isStream) {
                live.add(const GoFailure());
                context.showErrorSnackBar(error);
              },
              broadcastConnected: () {
                final broadcast = broadcastBloc.state.broadcast;
                socket.add(SocketStartBroadcast(broadcast.id));
              },
              broadcastReconnected: () {
                final broadcast = broadcastBloc.state.broadcast;
                chat.add(InitializeChatList(broadcast));
                socket.add(SocketGetMessages(broadcast.id));
                participants.add(GetLiveParticipants(broadcast.id));
                timer.start();
                timer.setAndStart(broadcast.startTime);
                live.add(const GoLive());
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
              broadcastStarted: () {
                final broadcast = broadcastBloc.state.broadcast;
                chat.add(InitializeChatList(broadcast));
                socket.add(SocketGetMessages(broadcast.id));
                participants.add(GetLiveParticipants(broadcast.id));
                timer.start();
                live.add(const LiveStarted());
                live.add(const GoLive());
              },
              broadcastEnded: () async {
                final broadcast = broadcastBloc.state.broadcast;
                participants.add(GetAllParticipants(broadcast.id));
                timer.stop();
                live.add(const LiveReset());
                if (router.state!.name == Routes.broadcastTab) {
                  await router.replace<void>(Routes.endedBroadcast);
                } else {
                  await router.push<void>(Routes.endedBroadcast);
                }
              },
              broadcastJoined: () {
                final broadcast = streamBloc.state.broadcast;
                socket.add(SocketGetMessages(broadcast.id));
                chat.add(InitializeChatList(broadcast));
                participants.add(GetLiveParticipants(broadcast.id));
                timer.setAndStart(broadcast.startTime);
                live.add(const LiveStarted());
                live.add(const GoStreaming());
              },
              broadcastLeft: () {
                live.add(const LiveReset());
                participants.add(const ParticipantsReset());
                chat.add(const ChatReset());
                timer.dispose();
                streamBloc.add(const StreamReset());
                router.go(Routes.home);
              },
              endedBroadcast: (data) {
                if (live.state is Streaming) {
                  live.add(const LiveReset());
                  livekit.add(const LiveKitDisconnect());
                  participants.add(const ParticipantsReset());
                  chat.add(const ChatReset());
                  streamBloc.add(const StreamReset());
                  timer.dispose();
                  context.showErrorSnackBar(data.reason.message);
                  router.go(Routes.home);
                }
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

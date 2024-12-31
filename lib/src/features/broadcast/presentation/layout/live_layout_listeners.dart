import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class LiveLayoutListeners extends StatelessWidget {
  const LiveLayoutListeners({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final chat = context.read<ChatBloc>();
    final live = context.read<LiveBloc>();
    final livekit = context.read<LiveKitBloc>();
    final participants = context.read<ParticipantsBloc>();
    final socket = context.read<SocketBloc>();
    final timer = context.read<TimerCubit>();

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
              broadcastConnected: () async {
                final bId = context.read<BroadcastBloc>().state.broadcast.id;
                await di<BackgroundService>().invokeBroadcastInBackground();
                socket.add(SocketStartBroadcast(bId));
              },
              streamConnected: () async {
                final bId = context.read<StreamBloc>().state.broadcast.id;
                await di<BackgroundService>().invokeStreamInBackground();
                socket.add(SocketJoinBroadcast(bId));
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
                final broadcast = context.read<BroadcastBloc>().state.broadcast;
                chat.add(InitializeChat(broadcast));
                socket.add(SocketGetMessages(broadcast.id));
                participants.add(GetLiveParticipants(broadcast.id));
                timer.start();
                live.add(const LiveStarted());
                live.add(const GoLive());
                di<BackgroundService>().startBackgroundService();
              },
              broadcastEnded: () {
                final broadcast = context.read<BroadcastBloc>().state.broadcast;
                di<BackgroundService>().endBackgroundTask();
                participants.add(GetAllParticipants(broadcast.id));
                timer.stop();
                live.add(const LiveReset());
                router.replace<void>(Routes.endedBroadcast);
              },
              broadcastJoined: () {
                final broadcast = context.read<StreamBloc>().state.broadcast;
                socket.add(SocketGetMessages(broadcast.id));
                chat.add(InitializeChat(broadcast));
                participants.add(GetLiveParticipants(broadcast.id));
                timer.setAndStart(broadcast.startTime);
                live.add(const LiveStarted());
                live.add(const GoStreaming());
                di<BackgroundService>().startBackgroundService();
              },
              broadcastLeft: () {
                di<BackgroundService>().endBackgroundTask();
                live.add(const LiveReset());
                router.go(Routes.home);
              },
              endedBroadcast: (data) {
                if (live.state is Live) return;
                di<BackgroundService>().endBackgroundTask();
                live.add(const LiveReset());
                router.go(Routes.home);
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

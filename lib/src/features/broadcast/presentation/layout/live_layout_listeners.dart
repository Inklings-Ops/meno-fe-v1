import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class LiveLayoutListeners extends StatelessWidget {
  const LiveLayoutListeners({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final liveBloc = context.watch<LiveBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<LiveKitBloc, LiveKitState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            state.status.whenOrNull(
              failed: (error, isStream) {
                context.read<LiveBloc>().add(const GoFailure());
                context.showErrorSnackBar(error);
                if (isStream) return router.pop();
              },
              broadcastConnected: () async {
                final bId = context.read<BroadcastBloc>().state.broadcast.id;
                await di<BackgroundService>().invokeBroadcastInBackground();
                if (!context.mounted) return;
                context.read<SocketBloc>().add(SocketStartBroadcast(bId));
              },
              streamConnected: () async {
                final bId = context.read<StreamBloc>().state.broadcast.id;
                await di<BackgroundService>().invokeStreamInBackground();
                if (!context.mounted) return;
                context.read<SocketBloc>().add(SocketJoinBroadcast(bId));
              },
            );
          },
        ),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (error, isStream) {
                context.read<LiveBloc>().add(const GoFailure());
                context.read<LiveKitBloc>().add(const LiveKitDisconnect());
                isStream ? router.pop() : context.showErrorSnackBar(error);
              },
              broadcastStarted: () {
                final broadcast = context.read<BroadcastBloc>().state.broadcast;
                final bId = broadcast.id;
                context.read<ChatBloc>().add(InitializeChat(broadcast));
                context.read<SocketBloc>().add(SocketGetMessages(bId));
                context.read<ParticipantsBloc>().add(GetLiveParticipants(bId));
                context.read<TimerCubit>().start();
                context.read<LiveBloc>().add(const LiveStarted());
                context.read<LiveBloc>().add(const GoLive());
                di<BackgroundService>().startBackgroundService();
              },
              broadcastEnded: () {
                final bId = context.read<BroadcastBloc>().state.broadcast.id;
                di<BackgroundService>().endBackgroundTask();
                context.read<ParticipantsBloc>().add(GetAllParticipants(bId));
                context.read<TimerCubit>().stop();
                context.read<LiveBloc>().add(const LiveReset());
                router.replace<void>(Routes.endedBroadcast);
              },
              broadcastJoined: () {
                final broadcast = context.read<StreamBloc>().state.broadcast;
                final bId = broadcast.id;
                context.read<SocketBloc>().add(SocketGetMessages(bId));
                context.read<ChatBloc>().add(InitializeChat(broadcast));
                context.read<ParticipantsBloc>().add(GetLiveParticipants(bId));
                context.read<TimerCubit>().setAndStart(broadcast.startTime);
                context.read<LiveBloc>().add(const LiveStarted());
                context.read<LiveBloc>().add(const GoStreaming());
                di<BackgroundService>().startBackgroundService();
              },
              broadcastLeft: () {
                di<BackgroundService>().endBackgroundTask();
                context.read<LiveBloc>().add(const LiveReset());
                router.go(Routes.home);
              },
              endedBroadcast: (data) {
                if (liveBloc.state is Live) return;
                di<BackgroundService>().endBackgroundTask();
                context.read<LiveBloc>().add(const LiveReset());
                router.go(Routes.home);
              },
              messagesReceived: (chats) {
                context.read<ChatBloc>().add(LoadChatMessages(chats));
              },
            );
          },
        ),
      ],
      child: child,
    );
  }
}

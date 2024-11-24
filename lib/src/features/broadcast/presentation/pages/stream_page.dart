import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class StreamPage extends StatelessWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bibleFacade = di<IBibleFacade>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VersesCubit(facade: bibleFacade)),
        BlocProvider(create: (_) => ScripturePickerCubit(facade: bibleFacade)),
        BlocProvider(create: (_) => TransBloc(facade: bibleFacade)),
      ],
      child: const StreamPageView(),
    );
  }
}

class StreamPageView extends HookWidget {
  const StreamPageView({super.key});

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
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            state.status.whenOrNull(
              failed: (error, _) {
                context.read<LiveBloc>().add(const GoFailure());
                router.pop();
              },
              streamConnected: () async {
                await di<BackgroundService>().invokeStreamInBackground();
                socket.add(SocketJoinBroadcast(id));
              },
            );
          },
        ),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (error, _) {
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
                di<BackgroundService>().startBackgroundService();
              },
              messagesReceived: (chats) {
                context.read<ChatBloc>().add(LoadChatMessages(chats));
              },
              endedBroadcast: (data) {
                di<BackgroundService>().endBackgroundTask();
                context.read<LiveBloc>().add(const LiveReset());
                router.go(Routes.home);
              },
              broadcastLeft: () {
                di<BackgroundService>().endBackgroundTask();
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

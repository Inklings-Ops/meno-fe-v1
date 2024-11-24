import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class BroadcastPage extends StatelessWidget {
  const BroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bibleFacade = di<IBibleFacade>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VersesCubit(facade: bibleFacade)),
        BlocProvider(create: (_) => ScripturePickerCubit(facade: bibleFacade)),
        BlocProvider(create: (_) => TransBloc(facade: bibleFacade)),
      ],
      child: const BroadcastPageView(),
    );
  }
}

class BroadcastPageView extends HookWidget {
  const BroadcastPageView({super.key});

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    final controller = useTabController(initialLength: 4);

    final broadcastId = context.read<BroadcastBloc>().state.broadcast.id;

    final participantsBloc = context.read<ParticipantsBloc>();
    final socket = context.watch<SocketBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<LiveKitBloc, LiveKitState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            state.status.whenOrNull(
              failed: (error, _) {
                context.read<LiveBloc>().add(const GoFailure());
                context.showErrorSnackBar(error);
              },
              broadcastConnected: () async {
                await di<BackgroundService>().invokeBroadcastInBackground();
                socket.add(SocketStartBroadcast(broadcastId));
              },
            );
          },
        ),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (error, _) {
                context.read<LiveBloc>().add(const GoFailure());
                context.showErrorSnackBar(error);
              },
              broadcastStarted: () {
                socket.add(SocketGetMessages(broadcastId));
                participantsBloc.add(GetLiveParticipants(broadcastId));
                context.read<TimerCubit>().start();
                context.read<LiveBloc>().add(const LiveStarted());
                context.read<LiveBloc>().add(const GoLive());
                di<BackgroundService>().startBackgroundService();
              },
              broadcastEnded: () {
                di<BackgroundService>().endBackgroundTask();
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
      child: Stack(
        children: [
          MScaffold(
            padding: EdgeInsets.zero,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  constraints: const BoxConstraints(minHeight: 32),
                  child: TabBar(
                    controller: controller,
                    tabs: const [
                      Tab(text: 'Broadcast'),
                      Tab(text: 'Chats'),
                      Tab(text: 'Live Bible'),
                      Tab(text: 'Notes'),
                    ],
                  ),
                ),
              ),
            ),
            body: MTabBarView(
              controller: controller,
              children: const [
                BroadcastTab(),
                ChatTab(),
                LiveBibleTab(),
                NotesTab(),
              ],
              onPageChanged: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
          BlocBuilder<LiveBloc, LiveState>(
            builder: (context, state) => state.maybeWhen(
              orElse: () => const SizedBox(),
              loading: () => ColoredBox(
                color: Colors.black.withOpacity(0.8),
                child: const SizedBox.expand(
                  child: Center(child: MLoadingIndicator(130, 130)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

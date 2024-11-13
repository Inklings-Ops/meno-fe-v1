import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LiveBroadcastsBloc(facade: di<IBroadcastFacade>())..init(),
      child: const HomeView(),
    );
  }
}

class HomeView extends HookWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final recentlyLiveBloc = context.read<RecentlyLiveCubit>();
    final liveBroadcastsCubit = context.read<LiveBroadcastsBloc>();

    Future<void> onRefresh() async {
      final liveBroadcasts = liveBroadcastsCubit.stream.first;
      liveBroadcastsCubit.add(const LiveBroadcastsEvent.getLiveBroadcasts());

      final recentlyLive = recentlyLiveBloc.stream.first;
      await recentlyLiveBloc.fetch();

      await Future.wait([liveBroadcasts, recentlyLive]);
    }

    final isStreaming = context.select<LiveBloc, bool>((bloc) {
      return bloc.state.maybeWhen(orElse: () => false, streaming: () => true);
    });

    return BlocListener<SocketBloc, SocketState>(
      listener: (context, state) {
        state.whenOrNull(
          broadcastEnded: () {
            final bId = context.read<BroadcastBloc>().state.broadcast.id;
            context.read<ParticipantsBloc>().add(GetAllParticipants(bId));
            context.read<TimerCubit>().stop();
            context.read<LiveBloc>().add(const LiveReset());
            router.push<void>(Routes.endedBroadcast);
          },
          endedBroadcast: (data) {
            if (!isStreaming) return;
            context.read<LiveBloc>().add(const LiveReset());
            context.read<LiveKitBloc>().add(const LiveKitDisconnect());
            context.read<ParticipantsBloc>().add(const ParticipantsReset());
            context.read<ChatBloc>().add(const ChatReset());
            context.read<StreamBloc>().add(const StreamReset());
            context.read<TimerCubit>().dispose();
            context.showErrorSnackBar(data.reason.message);
          },
          broadcastLeft: () {
            context.read<LiveBloc>().add(const LiveReset());
            context.read<LiveKitBloc>().add(const LiveKitDisconnect());
            context.read<ParticipantsBloc>().add(const ParticipantsReset());
            context.read<ChatBloc>().add(const ChatReset());
            context.read<StreamBloc>().add(const StreamReset());
            context.read<TimerCubit>().dispose();
          },
        );
      },
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              children: [
                BlocBuilder<LiveBloc, LiveState>(
                  builder: (context, state) => state.maybeWhen(
                    orElse: () => Spaces.verticalXLarge,
                    streaming: LiveStreamActivityCard.new,
                    live: LiveBroadcastActivityCard.new,
                  ),
                ),
                // BlocBuilder<BroadcastBloc, BroadcastState>(
                //   builder: (context, state) {
                //     final hostDisconnected = state.hostDisconnected;
                //     final broadcast = state.broadcast;
                //     if (hostDisconnected && broadcast != Broadcast.empty()) {
                //       return ActivityCard(
                //         badgeTitle: 'Reconnect back',
                //         broadcast: broadcast,
                //         actionButtonLabel: 'Rejoin',
                //         action: () {
                //           context
                //               .read<BroadcastBloc>()
                //               .add(BroadcastReconnectRequested(broadcast));
                //           context
                //               .read<ChatBloc>()
                //               .add(ChatInitialized(broadcast));
                //           context
                //               .read<ParticipantsBloc>()
                //               .add(ParticipantsInitialized(broadcast));
                //           context
                //               .read<TimerCubit>()
                //               .setAndStart(broadcast.startTime);
                //           context.read<MenoBloc>().update(const MLive());
                //           // router.push<void>(Routes.broadcast);
                //         },
                //       );
                //     } else {
                //       return const SizedBox();
                //     }
                //   },
                // ),
                const LiveForYou(),
                const NowLive(),
                const RecentlyLive(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

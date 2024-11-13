import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

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

    return Scaffold(
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
    );
  }
}

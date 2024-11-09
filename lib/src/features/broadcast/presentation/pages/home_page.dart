import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LiveBroadcastsBloc(
        facade: di<IBroadcastFacade>(),
        socket: di<SocketService>(),
      )..init(),
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

    final isStreaming = context.select(
      (MenoBloc bloc) => bloc.state.maybeWhen(
        orElse: () => false,
        streaming: () => true,
      ),
    );

    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: MultiBlocListener(
            listeners: [
              BlocListener<BroadcastBloc, BroadcastState>(
                listenWhen: (p, c) => p.status != c.status,
                listener: (context, state) {
                  state.status.whenOrNull(
                    failed: context.showBroadcastError,
                    broadcastEnded: () => _onEndedBroadcast(context),
                  );
                },
              ),
              BlocListener<StreamBloc, StreamState>(
                listener: (context, state) {
                  state.status.whenOrNull(
                    left: () => _handleStreamEnd(context),
                    streamEnded: (data) {
                      if (!isStreaming) return;
                      final broadcast = data.broadcastDetails;
                      final creator =
                          broadcast.creatorId ?? broadcast.creator?.id;
                      final authUser =
                          di<ISessionContext>().credential!.user.id;
                      if (creator != authUser.getOr()) {
                        _handleStreamEnd(context);
                        context.showErrorSnackBar(data.reason.message);
                      }
                    },
                  );
                },
              ),
            ],
            child: Column(
              children: [
                BlocBuilder<MenoBloc, MenoState>(
                  builder: (context, state) => state.maybeWhen(
                    orElse: () => Spaces.verticalXLarge,
                    streaming: LiveStreamActivityCard.new,
                    live: LiveBroadcastActivityCard.new,
                  ),
                ),
                BlocBuilder<BroadcastBloc, BroadcastState>(
                  bloc: context.read<BroadcastBloc>()..checkForLiveBroadcasts(),
                  builder: (context, state) {
                    final hostDisconnected = state.hostDisconnected;
                    final broadcast = state.broadcast;
                    if (hostDisconnected && broadcast != Broadcast.empty()) {
                      return ActivityCard(
                        badgeTitle: 'Reconnect back',
                        broadcast: broadcast,
                        actionButtonLabel: 'Rejoin',
                        action: () {
                          context
                              .read<BroadcastBloc>()
                              .add(BroadcastReconnectRequested(broadcast));
                          context
                              .read<ChatBloc>()
                              .add(ChatInitialized(broadcast));
                          context
                              .read<ParticipantsBloc>()
                              .add(ParticipantsInitialized(broadcast));
                          context
                              .read<TimerCubit>()
                              .setAndStart(broadcast.startTime);
                          context.read<MenoBloc>().update(const MLive());
                          // router.push<void>(Routes.broadcast);
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
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

  void _handleStreamEnd(BuildContext context) {
    context.read<MenoBloc>().update(const MOffAir());
    router.go(Routes.home);

    context.read<StreamBloc>().add(const StreamReset());
    context.read<ParticipantsBloc>().add(const ParticipantsReset());
    context.read<ChatBloc>().add(const ChatReset());

    di<LiveKitService>().dispose();
    context.read<TimerCubit>().dispose();
  }

  void _onEndedBroadcast(BuildContext context) {
    context.read<TimerCubit>().stop();
    di<LiveKitService>().disconnect();
    context.read<ParticipantsBloc>().add(const AllParticipantsFetchPressed());
    context.read<MenoBloc>().update(const MOffAir());
    context.showModal<void>(
      const BroadcastEndedModal(),
      enableDrag: false,
      useRootNavigator: true,
      isDismissible: false,
      isScrollControlled: true,
    );
  }
}

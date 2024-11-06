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

    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: BlocListener<StreamBloc, StreamState>(
            listener: (context, state) {
              state.status.whenOrNull(
                left: () => _handleStreamEnd(context),
                streamEnded: (data) {
                  final broadcast = data.broadcastDetails;
                  final creator = broadcast.creatorId ?? broadcast.creator?.id;
                  final authUser = di<ISessionContext>().credential!.user.id;
                  if (creator != authUser.getOr()) {
                    _handleStreamEnd(context);
                    context.showErrorSnackBar(data.reason.message);
                  }
                },
              );
            },
            child: Column(
              children: [
                BlocBuilder<MenoBloc, MenoState>(
                  builder: (context, state) => state.maybeWhen(
                    orElse: () => Spaces.verticalXLarge,
                    streaming: LiveStreamActivityCard.new,
                    live: LiveBroadcastActivityCard.new,
                  ),
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
}

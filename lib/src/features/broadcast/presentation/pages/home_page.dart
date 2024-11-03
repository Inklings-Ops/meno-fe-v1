import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        di<IBibleFacade>().init();
        return;
      },
      const [],
    );

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
                ended: (data) {
                  _handleStreamEnd(context);
                  context.showErrorSnackBar(data.reason.message);
                },
                left: () => _handleStreamEnd(context),
              );
            },
            child: Column(
              children: [
                BlocBuilder<MenoBloc, MenoState>(
                  builder: (context, state) => state.maybeWhen(
                    orElse: () => Spaces.verticalXLarge,
                    streaming: LiveActivityCard.new,
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

    context.read<LiveKitService>().dispose();
    context.read<TimerCubit>().dispose();
  }
}

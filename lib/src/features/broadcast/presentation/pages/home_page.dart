import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

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
    );
  }
}

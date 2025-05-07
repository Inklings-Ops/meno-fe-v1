import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final recentlyLiveBloc = context.read<RecentlyLiveCubit>();
    final liveBroadcastsCubit = context.read<LiveBroadcastsBloc>();

    Future<void> onRefresh() async {
      final liveBroadcasts = liveBroadcastsCubit.stream.first;
      liveBroadcastsCubit.add(const GetLiveBroadcasts());

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
              const LiveForYou(),
              const NowLiveSection(),
              const RecentlyLiveSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

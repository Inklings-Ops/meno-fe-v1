import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      di<IBibleFacade>().init();
      return;
    }, const []);
    
    final recentlyLiveBloc = context.read<RecentlyLiveCubit>();
    final liveBroadcastsCubit = context.read<LiveBroadcastsBloc>();

    Future<void> onRefresh() async {
      Future liveBroadcasts = liveBroadcastsCubit.stream.first;
      liveBroadcastsCubit.add(const LiveBroadcastsEvent.getLiveBroadcasts());

      Future recentlyLive = recentlyLiveBloc.stream.first;
      recentlyLiveBloc.fetch();

      await Future.wait([liveBroadcasts, recentlyLive]);
    }

    return MScaffold(
      appBar: const HomeAppBar(),
      padding: EdgeInsets.zero,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Spaces.verticalXLarge,
              LiveActivityCard(),
              LiveForYou(),
              NowLive(),
              RecentlyLive(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

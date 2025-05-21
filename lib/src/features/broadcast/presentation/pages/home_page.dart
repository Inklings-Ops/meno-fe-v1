import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final recentlyLiveBloc = context.read<RecentlyLiveBloc>();
    final nowLiveBloc = context.read<NowLiveBloc>();

    Future<void> onRefresh() async {
      final liveBroadcasts = nowLiveBloc.stream.first;
      nowLiveBloc.add(const NowLiveStarted());

      final recentlyLive = recentlyLiveBloc.stream.first;
      recentlyLiveBloc.add(const RecentlyLiveStarted());

      await Future.wait([liveBroadcasts, recentlyLive]);
    }

    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              LiveBroadcastActivityCard(),
              LiveForYou(),
              NowLiveSection(),
              RecentlyLiveSection(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

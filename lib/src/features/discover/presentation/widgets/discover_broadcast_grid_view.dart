import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';

class DiscoverBroadcastGridView extends HookWidget {
  const DiscoverBroadcastGridView({
    super.key,
    required this.broadcasts,
    required this.filter,
  });
  final List<Broadcast?> broadcasts;
  final Filter filter;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24.toScale,
        crossAxisSpacing: 24.toScale,
        childAspectRatio: (159.50 / 176).toScale,
      ),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 32).radius,
      itemBuilder: (context, i) {
        final broadcast = broadcasts[i]!;
        return switch (filter) {
          Filter.recentlyLive => _RecentlyLiveCard(broadcast: broadcast),
          Filter.nowLive => _NowLiveCard(broadcast: broadcast),
          _ => const EmptyListWidget(),
        };
      },
      itemCount: broadcasts.length,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

class _NowLiveCard extends StatelessWidget {
  const _NowLiveCard({required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MCard.live(
      title: broadcast.title.getOr(),
      imageUrl: broadcast.imageUrl,
      host: broadcast.fullName!,
      liveCount: broadcast.totalListeners,
    );
  }
}

class _RecentlyLiveCard extends StatelessWidget {
  const _RecentlyLiveCard({required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return MCard.recentlyLive(
      title: broadcast.title.getOr(),
      imageUrl: broadcast.imageUrl,
      host: broadcast.fullName,
    );
  }
}

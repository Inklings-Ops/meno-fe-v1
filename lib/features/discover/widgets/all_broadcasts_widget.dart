import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/discover/discover.dart';
import 'package:meno_design_system/meno_design_system.dart';

class AllBroadcastsWidget extends StatelessWidget {
  const AllBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spaces.verticalXLarge,
          _NowLiveSection(key: Key('DiscoverNowLiveSection')),
          Spaces.verticalXXLarge,
          _RecentlyLiveSection(key: Key('DiscoverRecentlyLiveSection')),
          Spaces.verticalXXLarge,
        ],
      ),
    );
  }
}

class _NowLiveSection extends WatchingWidget {
  const _NowLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.nowLive(),
      );
    });

    return BroadcastSectionWidget(
      title: 'Now Live',
      maxContentHeight: 376,
      titleIcon: Assets.images.flame.image(height: 24, width: 24),
      onSeeAll: di<DiscoverManager>().goToNowLive,
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        gridCrossAxisSpacing: 24,
        gridMainAxisSpacing: 24,
        layout: .verticalGrid,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();
          return BroadcastCard.liveCard(
            broadcast,
            key: ValueKey(broadcast.id.getOrCrash()),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _RecentlyLiveSection extends StatelessWidget {
  const _RecentlyLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.recentlyLive(),
      );
    });

    return BroadcastSectionWidget(
      title: 'Recently Live',
      maxContentHeight: 376,
      titleIcon: Assets.images.highVoltage.image(height: 24, width: 24),
      onSeeAll: di<DiscoverManager>().goToRecentlyLive,
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        gridCrossAxisSpacing: 24,
        gridMainAxisSpacing: 24,
        layout: .verticalGrid,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();
          return BroadcastCard.recentlyLiveCard(
            broadcast,
            key: ValueKey(broadcast.id.getOrCrash()),
            onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
          );
        },
      ),
    );
  }
}

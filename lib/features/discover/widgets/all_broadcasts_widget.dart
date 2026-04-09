import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
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
        query: BroadcastQuery.nowLive(
          pagination: const PaginationParams(size: 8),
        ),
        fetchMoreEnabled: false,
      );
    });

    return BroadcastSectionWidget(
      title: 'Now Live',
      maxContentHeight: 376,
      titleIcon: Assets.images.flame.image(height: 24, width: 24),
      onSeeAll: () => context.go(R.discoverNowLiveTab),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        gridCrossAxisSpacing: 24,
        gridMainAxisSpacing: 24,
        skeletonItem: BroadcastCard.skeletonLive,
        skeletonItemCount: 4,
        layout: .horizontalGrid,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();
          return BroadcastCard.nLive(
            broadcast,
            key: ValueKey(broadcast.id.getOrCrash()),
            onTap: () => context.push(R.preStream(broadcast.id.getOrCrash())),
          );
        },
      ),
    );
  }
}

class _RecentlyLiveSection extends WatchingWidget {
  const _RecentlyLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.recentlyLive(
          pagination: const PaginationParams(size: 8),
        ),
        fetchMoreEnabled: false,
      );
    });

    return BroadcastSectionWidget(
      title: 'Recently Live',
      maxContentHeight: 376,
      titleIcon: Assets.images.highVoltage.image(height: 24, width: 24),
      onSeeAll: () => context.go(R.discoverRecentlyLiveTab),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        gridCrossAxisSpacing: 24,
        gridMainAxisSpacing: 24,
        skeletonItem: BroadcastCard.skeletonRecentlyLive,
        skeletonItemCount: 4,
        layout: .horizontalGrid,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();
          return BroadcastCard.rLive(
            broadcast,
            key: ValueKey(broadcast.id.getOrCrash()),
            onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
          );
        },
      ),
    );
  }
}

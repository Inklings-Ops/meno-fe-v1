import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/image_value_objects.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/broadcast/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(),
      body: SingleChildScrollView(
        clipBehavior: .none,
        padding: .only(bottom: 32),
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          children: <Widget>[
            LiveSessionBanner(),
            Spaces.verticalXLarge,
            _LiveForYouSection(),
            Spaces.verticalXXLarge,
            _NowLiveSection(),
            Spaces.verticalXXLarge,
            _RecentlyLiveSection(),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends WatchingWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => ToolBarHeights.home;

  @override
  Widget build(BuildContext context) {
    final user = watchValue((UserManager m) => m.currentUser);
    return MAppBar.home(
      title: user.fullName.getOrCrash(),
      avatarImageUrl: user.image?.getUrl(),
      onAvatarTap: () => context.go(R.myProfile),
      onNotificationBellTap: () => context.push(R.notifications),
    );
  }
}

class _LiveForYouSection extends WatchingWidget {
  const _LiveForYouSection();

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.forYou(
          pagination: const PaginationParams(size: 8),
        ),
        fetchMoreEnabled: false,
      );
    });

    final params = feedSource.currentQuery.toRouterParams;

    return BroadcastSectionWidget(
      title: 'Live For You',
      titleIcon: Assets.images.sparkles.image(height: 24, width: 24),
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        layout: .horizontalList,
        skeletonItem: BroadcastCard.skeletonLive,
        skeletonItemCount: 4,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();
          return BroadcastCard.nLive(
            broadcast,
            key: ValueKey(broadcast.id.getOrCrash()),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _NowLiveSection extends WatchingWidget {
  const _NowLiveSection();

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

    final params = feedSource.currentQuery.toRouterParams;

    return BroadcastSectionWidget(
      title: 'Now Live',
      titleIcon: Assets.images.flame.image(height: 24, width: 24),
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        layout: .horizontalList,
        skeletonItem: BroadcastCard.skeletonLive,
        skeletonItemCount: 4,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();
          return BroadcastCard.nLive(
            broadcast,
            key: ValueKey(broadcast.id.getOrCrash()),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _RecentlyLiveSection extends WatchingWidget {
  const _RecentlyLiveSection();

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

    final params = BroadcastQuery.recentlyLive().toRouterParams;

    return BroadcastSectionWidget(
      title: 'Recently Live',
      titleIcon: Assets.images.highVoltage.image(height: 24, width: 24),
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        layout: .horizontalList,
        skeletonItem: BroadcastCard.skeletonRecentlyLive,
        skeletonItemCount: 4,
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

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/image_value_objects.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/_shared/manager/live_feed_data_source.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class HomePage extends WatchingWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final liveForFeed = createOnce(() {
      return LiveFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.forYou(),
      );
    });

    final nowLiveFeed = createOnce(() {
      return LiveFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.nowLive(),
      );
    });

    final recentlyLiveFeed = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        initialQuery: BroadcastQuery.recentlyLive(),
      );
    });

    return Scaffold(
      appBar: const _AppBar(),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          liveForFeed.updateDataCommand.runAsync(),
          nowLiveFeed.updateDataCommand.runAsync(),
          recentlyLiveFeed.updateDataCommand.runAsync(),
        ]),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            spacing: Insets.xxl,
            children: <Widget>[
              const LiveSessionBanner(),
              _LiveForYouSection(feedSource: liveForFeed),
              _NowLiveSection(feedSource: nowLiveFeed),
              _RecentlyLiveSection(feedSource: recentlyLiveFeed),
            ],
          ),
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

class _LiveForYouSection extends StatelessWidget {
  const _LiveForYouSection({required this.feedSource});
  final BroadcastFeedDataSource feedSource;

  @override
  Widget build(BuildContext context) {
    final params = feedSource.currentQuery.toApiParams;
    return HomeBroadcastSectionWidget(
      title: Row(
        children: [
          const MText('Live For You'),
          Spaces.horizontalSmall,
          Assets.images.flame.image(height: 24, width: 24),
        ],
      ),
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        layout: .horizontalList,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();

          return BroadcastCard.live(
            key: ValueKey(broadcast.id.getOrCrash()),
            broadcast: broadcast,
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _NowLiveSection extends StatelessWidget {
  const _NowLiveSection({required this.feedSource});
  final BroadcastFeedDataSource feedSource;

  @override
  Widget build(BuildContext context) {
    final params = feedSource.currentQuery.toApiParams;
    return HomeBroadcastSectionWidget(
      title: Row(
        children: [
          const MText('Now Live'),
          Spaces.horizontalSmall,
          Assets.images.flame.image(height: 24, width: 24),
        ],
      ),
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        layout: .horizontalList,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();

          return BroadcastCard.live(
            key: ValueKey(broadcast.id.getOrCrash()),
            broadcast: broadcast,
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _RecentlyLiveSection extends StatelessWidget {
  const _RecentlyLiveSection({required this.feedSource});
  final BroadcastFeedDataSource feedSource;

  @override
  Widget build(BuildContext context) {
    final params = BroadcastQuery.recentlyLive().toRouterParams;

    return HomeBroadcastSectionWidget(
      title: Row(
        children: [
          const MText('Recently Live'),
          Spaces.horizontalSmall,
          Assets.images.highVoltage.image(height: 24, width: 24),
        ],
      ),
      onSeeAll: () => context.pushNamed(R.broadcasts, queryParameters: params),
      builder: (context) => FeedWidget(
        feedSource: feedSource,
        horizontalItemExtent: 148,
        layout: .horizontalList,
        padding: const .symmetric(horizontal: 16),
        itemBuilder: (context, broadcast) {
          if (broadcast == null) return const SizedBox.shrink();

          return BroadcastCard.recentlyLiveCard(
            key: ValueKey(broadcast.id.getOrCrash()),
            broadcast: broadcast,
            onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/image_value_objects.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class HomePage extends WatchingWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final recentlyLiveFeedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        initialQuery: BroadcastQuery.recentlyLive(),
      );
    });

    return Scaffold(
      appBar: const _AppBar(key: Key('homeAppBar')),
      body: RefreshIndicator(
        onRefresh: () =>
            Future.wait([recentlyLiveFeedSource.updateDataCommand.runAsync()]),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            spacing: Insets.xxl,
            children: <Widget>[
              const LiveSessionBanner(),
              const HomeLiveForYouSection(),
              // const NowLiveSectionWidget(),
              HomeRecentlyLiveSection(feedSource: recentlyLiveFeedSource),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends WatchingWidget implements PreferredSizeWidget {
  const _AppBar({super.key});

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

  @override
  Size get preferredSize => ToolBarHeights.home;
}

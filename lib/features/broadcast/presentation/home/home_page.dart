import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/profile/applications/applications.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class HomePage extends WatchingWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserIdOption = watchValue((UserManager m) => m.currentUserId);
    final currentUserId = currentUserIdOption.toNullable();

    return Scaffold(
      appBar: const _AppBar(key: Key('homeAppBar')),
      body: RefreshIndicator(
        onRefresh: () async => onRefresh(context),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            spacing: Insets.xxl,
            children: <Widget>[
              if (currentUserId != null)
                LiveBroadcastActivityCard(currentUserId: currentUserId),
              const LiveForYouSectionWidget(),
              const NowLiveSectionWidget(),
              const RecentlyLiveSectionWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh(BuildContext context) async {
    final nowLiveManager = di<NowLiveBroadcastsManager>();
    final recentlyLiveManager = di<RecentlyLiveBroadcastsManager>();
    try {
      await nowLiveManager.initialize.runAsync();
      await recentlyLiveManager.fetch.runAsync();
    } catch (e) {
      if (context.mounted) context.showErrorSnackBar(e.toString());
    }
  }
}

class _AppBar extends WatchingWidget implements PreferredSizeWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final profileOption = watchValue((MyProfileManager m) => m.profile);
    return profileOption.match(
      () => const SizedBox(),
      (profile) => MAppBar.home(
        title: profile.fullName.getOrCrash(),
        avatarImageUrl: profile.image?.getUrl(),
        onAvatarTap: () => context.go(R.myProfile),
        onNotificationBellTap: () => context.push(R.notifications),
      ),
    );
  }

  @override
  Size get preferredSize => ToolBarHeights.home;
}

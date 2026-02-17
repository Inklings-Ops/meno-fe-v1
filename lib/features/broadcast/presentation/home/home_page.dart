import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final nowLiveManager = di<NowLiveBroadcastsManager>();
    final recentlyLiveManager = di<RecentlyLiveBroadcastsManager>();

    Future<void> onRefresh() async {
      try {
        await nowLiveManager.initialize.runAsync();
        await recentlyLiveManager.fetch.runAsync();
      } catch (e) {
        if (context.mounted) context.showErrorSnackBar(e.toString());
      }
    }

    return Scaffold(
      appBar: const _AppBar(key: Key('homeAppBar')),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: const SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            spacing: Insets.xxl,
            children: <Widget>[
              // LiveBroadcastActivityCard(),
              // LiveForYou(),
              NowLiveSectionWidget(),
              RecentlyLiveSectionWidget(),
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
    final userOption = watchValue((UserManager m) => m.currentUser);
    return userOption.match(
      () => const SizedBox(),
      (user) => MAppBar.home(
        title: user.fullName.getOrCrash(),
        avatarImageUrl: user.imageUrl,
        onAvatarTap: () => context.go(R.myProfile),
        onNotificationBellTap: () => context.push(R.notifications),
      ),
    );
  }

  @override
  Size get preferredSize => ToolBarHeights.home;
}

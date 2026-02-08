import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/auth/application/application.dart';
import 'package:meno/shared/application/user_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final recentlyLiveBloc = context.read<RecentlyLiveBloc>();
    // final nowLiveBloc = context.read<NowLiveBloc>();
    //
    // Future<void> onRefresh() async {
    //   final liveBroadcasts = nowLiveBloc.stream.first;
    //   nowLiveBloc.add(const NowLiveStarted());
    //
    //   final recentlyLive = recentlyLiveBloc.stream.first;
    //   recentlyLiveBloc.add(const RecentlyLiveStarted());
    //
    //   await Future.wait([liveBroadcasts, recentlyLive]);
    // }

    return Scaffold(
      appBar: const _AppBar(key: Key('dashboardAppBar')),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          children: [
            MPrimaryButton(
              label: 'Logout',
              onPressed: di<AuthManager>().logout.run,
            ),
            // LiveBroadcastActivityCard(),
            // LiveForYou(),
            // NowLiveSection(),
            // RecentlyLiveSection(),
            const SizedBox(height: 20),
          ],
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

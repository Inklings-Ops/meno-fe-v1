import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/discover/applications/discover_recently_live_manager.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

const _kTabBarHeight = 32.0;

class MyProfilePage extends WatchingWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileOption = watchValue((MyProfileManager m) => m.profile);
    return profileOption.match(
      () => const MenoEmptyWidget(),
      (profile) => _Content(profile: profile),
    );
  }
}

class _Content extends WatchingStatefulWidget {
  const _Content({required this.profile});

  final Profile profile;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final tabController = createOnce(() {
      return TabController(length: 3, vsync: this);
    });

    final scrollController = createOnce(() {
      final controller = ScrollController();
      controller.addListener(() {
        if (!controller.hasClients) return;
        final max = controller.position.maxScrollExtent;
        final current = controller.offset;
        if (max - current <= 200) {
          return switch (tabController.index) {
            0 => di<DiscoverRecentlyLiveManager>().fetchMore.run(),
            _ => () {},
          };
        }
      });
      return controller;
    });

    final colors = MColorScheme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _ProfileAppBar(
                profile: widget.profile,
                tabController: tabController,
                innerBoxIsScrolled: innerBoxIsScrolled,
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: const [
              _RecentBroadcastsTab(),
              _AllBroadcastsTab(),
              _FavoritesTab(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() => Future.wait([
    di<MyProfileManager>().refresh.runAsync(),
    di<DiscoverRecentlyLiveManager>().refresh.runAsync(),
  ]);
}

class _LeadingAccent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: ColoredBox(
          color: colors.secondary,
          child: const SizedBox(height: 30, width: 3),
        ),
      ),
    );
  }
}

class _ProfileTitle extends StatelessWidget {
  const _ProfileTitle({required this.profile});

  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    final name = profile?.fullName.getOrNull() ?? '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => SwitchAccountModal.show(context),
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisSize: .min,
          children: [
            Container(
              width: 3,
              margin: const .symmetric(vertical: 2),
              color: colors.error,
            ),
            Spaces.horizontalMicro,
            MText(
              name,
              style: textTheme.heading3Bold,
              color: colors.onBackground,
            ),
            Spaces.horizontalSmall,
            const Icon(MIcons.chevron_down, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar({
    required this.profile,
    required this.tabController,
    required this.innerBoxIsScrolled,
  });

  final Profile profile;
  final TabController tabController;
  final bool innerBoxIsScrolled;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return DynamicSliverAppBar(
      toolbarHeight: kToolbarHeight + 8,
      backgroundColor: colors.background,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      forceElevated: innerBoxIsScrolled,
      elevation: innerBoxIsScrolled ? 1 : 0,
      shadowColor: colors.onBackground.withValues(alpha: 0.08),
      title: _ProfileTitle(profile: profile),
      actions: [
        MIconButton(
          icon: const Icon(MIcons.settings),
          color: colors.primary,
          onPressed: () => context.push(R.settings),
        ),
        Spaces.horizontalLarge,
      ],
      flexibleSpace: SafeArea(
        bottom: false,
        child: ProfileHeaderContent.myProfile(profile),
      ),
      bottom: PreferredSize(
        preferredSize: const .fromHeight(_kTabBarHeight),
        child: Container(
          color: colors.background,
          height: _kTabBarHeight,
          child: TabBar(
            controller: tabController,
            padding: const .symmetric(horizontal: 16),
            labelStyle: textTheme.captionMedium,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const .symmetric(horizontal: 16),
            tabs: const [
              Tab(text: 'Recent broadcasts'),
              Tab(text: 'All broadcasts'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentBroadcastsTab extends WatchingWidget {
  const _RecentBroadcastsTab();

  @override
  Widget build(BuildContext context) {
    final page = watchValue((DiscoverRecentlyLiveManager m) => m.broadcasts);

    final isLoading = watchValue(
      (DiscoverRecentlyLiveManager m) => m.initialize.isRunning,
    );

    final error = watchValue((DiscoverRecentlyLiveManager m) => m.error);

    return ProfileBroadcastListWidget(
      page: page,
      emptyListWidgetBuilder: (context) => ProfileEmptyBroadcastsListWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      ),
      errorWidgetBuilder: (context) => ProfileEmptyBroadcastsListWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      ),
      isLoading: isLoading && page.isEmpty,
      hasError: error != null,
    );
  }
}

class _AllBroadcastsTab extends WatchingWidget {
  const _AllBroadcastsTab();

  @override
  Widget build(BuildContext context) {
    final page = watchValue((DiscoverRecentlyLiveManager m) => m.broadcasts);

    final isLoading = watchValue(
      (DiscoverRecentlyLiveManager m) => m.initialize.isRunning,
    );

    final error = watchValue((DiscoverRecentlyLiveManager m) => m.error);

    return ProfileBroadcastListWidget(
      page: page,
      emptyListWidgetBuilder: (context) => ProfileEmptyBroadcastsListWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      ),
      errorWidgetBuilder: (context) => ProfileEmptyBroadcastsListWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      ),
      isLoading: isLoading && page.isEmpty,
      hasError: error != null,
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  const _FavoritesTab();

  @override
  Widget build(BuildContext context) {
    return ProfileEmptyBroadcastsListWidget(
      title: 'No favourite broadcasts yet',
      actionTitle: 'View recordings',
      action: () {},
    );
  }
}

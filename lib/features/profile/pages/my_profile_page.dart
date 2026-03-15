import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/features/profile/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

const _kTabBarHeight = 32.0;

class MyProfilePage extends WatchingStatefulWidget {
  const MyProfilePage._({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  static Widget builder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) => MyProfilePage._(
    key: const ValueKey<String>('MyProfilePage'),
    navigationShell: navigationShell,
    children: children,
  );

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  StatefulNavigationShell get _shell => widget.navigationShell;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: _shell.currentIndex,
      length: 3,
      vsync: this,
    );

    // Keep TabController → shell in sync when the user swipes.
    _tabController.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(MyProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep shell → TabController in sync when navigation is driven
    // programmatically (e.g. context.go / deep link).
    if (_tabController.index != _shell.currentIndex) {
      _tabController.index = _shell.currentIndex;
    }
  }

  void _onTabChanged() {
    // addListener fires on animation ticks too — only act on settled index.
    if (_tabController.indexIsChanging) return;
    if (_tabController.index == _shell.currentIndex) return;

    _shell.goBranch(
      _tabController.index,
      // Tapping the active tab pops to the branch root, mirroring
      // standard bottom-nav behaviour.
      initialLocation: _tabController.index == _shell.currentIndex,
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final userId = watchValue((UserManager m) => m.currentUserId).value;
    final profile = watchValue((MyProfileManager m) => m.profile);
    final isEmpty = profile.isEmpty;

    return Scaffold(
      key: ValueKey(userId),
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: di<MyProfileManager>().fetch.runAsync,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _ProfileAppBar(
              profile: profile,
              tabController: _tabController,
              innerBoxIsScrolled: innerBoxIsScrolled,
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              if (isEmpty) ...[
                const SizedBox.shrink(),
                const SizedBox.shrink(),
                const SizedBox.shrink(),
              ] else
                ...widget.children,
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTitle extends StatelessWidget {
  const _ProfileTitle({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final name = profile.fullName.getOrElse((_) => 'Unknown User');

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
    required this.innerBoxIsScrolled,
    required this.tabController,
  });

  final Profile profile;
  final bool innerBoxIsScrolled;
  final TabController tabController;

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
      flexibleSpace: ProfileHeaderContent.myProfile(profile),
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
            tabAlignment: .start,
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

class ProfileRecentBroadcastsTab extends WatchingWidget {
  const ProfileRecentBroadcastsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      final creatorId = di<UserManager>().currentUserId.value;
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.recentlyLive(creatorId: creatorId),
      );
    });

    return FeedWidget(
      feedSource: feedSource,
      padding: const .all(16),
      skeletonItem: BroadcastCard.skeletonRecentlyLiveTile,
      skeletonItemCount: 4,
      itemBuilder: (context, broadcast) {
        if (broadcast == null) return const SizedBox.shrink();
        return BroadcastCard.rLiveTile(
          broadcast,
          key: ValueKey(broadcast.id.getOrCrash()),
          onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
        );
      },
    );
  }
}

class ProfileAllBroadcastsTab extends WatchingWidget {
  const ProfileAllBroadcastsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      final creatorId = di<UserManager>().currentUserId.value;
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery(creatorId: creatorId),
      );
    });

    return FeedWidget(
      feedSource: feedSource,
      padding: const .all(16),
      skeletonItem: BroadcastCard.skeletonRecentlyLiveTile,
      skeletonItemCount: 4,
      itemBuilder: (context, broadcast) {
        if (broadcast == null) return const SizedBox.shrink();
        return BroadcastCard.rLiveTile(
          broadcast,
          key: ValueKey(broadcast.id.getOrCrash()),
          onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
        );
      },
    );
  }
}

class ProfileFavouritesTab extends WatchingWidget {
  const ProfileFavouritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final favourites = watchValue((FavouritesManager m) => m.favourites);

    if (favourites.isEmpty) {
      return const MenoEmptyWidget(title: 'No favourite broadcasts yet');
    }

    return ListView.separated(
      padding: const .all(Insets.lg),
      separatorBuilder: (_, __) => Spaces.verticalLarge,
      itemCount: favourites.length,
      itemBuilder: (context, index) {
        final favourite = favourites[index];
        if (favourite == null) return const SizedBox.shrink();
        return MRecentlyLiveListTile(
          title: favourite.title,
          creator: favourite.creatorName,
          imageUrl: favourite.imageUrl,
          onTap: () => context.push(R.broadcast(favourite.broadcastId)),
        );
      },
    );
  }
}

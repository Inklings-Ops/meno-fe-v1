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
    final profile = watchValue((MyProfileManager m) => m.profile);
    return _Content(profile: profile);
  }
}

class _Content extends StatefulWidget {
  const _Content({required this.profile});

  final Profile? profile;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (max - current <= 200) {
      switch (_tabController.index) {
        case 0:
          di<DiscoverRecentlyLiveManager>().fetchMore.run();
        case 1:
        case 2:
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          di<MyProfileManager>().refresh.runAsync(),
          di<DiscoverRecentlyLiveManager>().refresh.runAsync(),
        ]),
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: _computeExpandedHeight(profile),
                backgroundColor: colors.background,
                surfaceTintColor: Colors.transparent,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                elevation: innerBoxIsScrolled ? 1 : 0,
                shadowColor: colors.onBackground.withValues(alpha: 0.08),
                title: _ProfileTitle(profile: profile),
                titleSpacing: 0,
                leading: _LeadingAccent(),
                leadingWidth: 23,
                actions: [
                  MIconButton(
                    icon: const Icon(MIcons.settings),
                    color: colors.primary,
                    onPressed: () => context.push(R.settings),
                  ),
                  Spaces.horizontalLarge,
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: SafeArea(
                    bottom: false,
                    child: _ProfileHeader(profile: profile),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(_kTabBarHeight),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: _kTabBarHeight,
                      child: TabBar(
                        controller: _tabController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        labelStyle: textTheme.captionMedium,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        tabs: const [
                          Tab(text: 'Recent broadcasts'),
                          Tab(text: 'All broadcasts'),
                          Tab(text: 'Favorites'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
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

  /// Approximates the expanded height so FlexibleSpaceBar fits without
  /// clipping or unnecessary whitespace.
  ///
  /// kToolbarHeight  = pinned app-bar row
  /// 48              = tab bar
  /// Content below:  avatar row (80) + badge (36) + bio (72) + buttons (48) +
  ///                 spacing (~40)
  double _computeExpandedHeight(Profile? profile) {
    // Extra height when bio is present so text isn't clipped.
    final bioHeight = (profile?.bio != null) ? 72.0 : 0.0;
    return kToolbarHeight + _kTabBarHeight + 80 + 36 + bioHeight + 48 + 40;
  }
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MText(
            name,
            style: textTheme.heading3Bold,
            color: colors.onBackground,
          ),
          Spaces.horizontalSmall,
          Icon(MIcons.chevron_down, size: 20, color: colors.onBackground),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 8, 16, 0),
      child: ProfileHeaderContent.myProfile(profile!),
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

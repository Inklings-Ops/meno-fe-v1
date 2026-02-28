import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/discover/applications/discover_recently_live_manager.dart';
import 'package:meno/features/profile/applications/my_profile_manager.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:readmore/readmore.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _kTabBarHeight = 32.0;

class MyProfilePage extends WatchingWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final snapshot = watchFuture<GetIt, void>(
    //   (getIt) => getIt.allReady(timeout: const Duration(seconds: 30)),
    //   target: di,
    //   initialValue: null,
    // );
    //
    // if (snapshot.hasError) return MenoErrorWidget(error: snapshot.error);
    //
    // if (snapshot.isLoading) return const LoadingPage();

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

          // The scrollable body — each tab's list scrolls independently inside
          // the NestedScrollView, extending the unified scroll physics.
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
    final isLoading = profile == null;

    return Skeletonizer(
      enabled: isLoading,
      child: SingleChildScrollView(
        // Not interactive — this is inside FlexibleSpaceBar's background.
        // NestedScrollView drives the scroll; we just need the Column to size.
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + stats row
            Row(
              children: [
                MAvatar(radius: 40, url: profile?.imageUrl),
                const SizedBox(width: 24),
                Expanded(
                  child: _ProfileStats(
                    numberOfBroadcasts: profile?.numberOfBroadcasts,
                    numberOfSubscribers: profile?.numberOfSubscribers,
                    numberOfSubscriptions: profile?.numberOfSubscriptions,
                  ),
                ),
              ],
            ),
            Spaces.verticalLarge,

            // Account tier badge
            const _AccountUpgradeSection(),
            Spaces.verticalLarge,

            // Biography
            if (profile?.bio != null) ...[
              _ProfileBio(bio: profile!.bio!),
              Spaces.verticalLarge,
            ],

            // Edit + Share buttons
            const _ProfileButtons(),
            Spaces.verticalLarge,
          ],
        ),
      ),
    );
  }
}

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({
    this.numberOfBroadcasts = 0,
    this.numberOfSubscribers = 0,
    this.numberOfSubscriptions = 0,
  });

  final int? numberOfBroadcasts;
  final int? numberOfSubscribers;
  final int? numberOfSubscriptions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        children: [
          const SizedBox(width: 2),
          _StatItem(title: 'Broadcasts', count: numberOfBroadcasts ?? 0),
          const Spacer(),
          _StatItem(title: 'Subscribers', count: numberOfSubscribers ?? 0),
          const Spacer(),
          _StatItem(title: 'Subscriptions', count: numberOfSubscriptions ?? 0),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final colors = MColorScheme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MText(count.toString(), style: textTheme.heading3Medium),
        MText(
          title,
          style: textTheme.microMedium,
          color: colors.onBackgroundVariant,
        ),
      ],
    );
  }
}

class _AccountUpgradeSection extends StatelessWidget {
  const _AccountUpgradeSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          const MTag(title: 'FREE ACCOUNT', height: 24),
          Spaces.horizontalLarge,
          MTextButton(
            label: 'Upgrade to Premium',
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              textStyle: textTheme.captionMedium.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBio extends StatelessWidget {
  const _ProfileBio({required this.bio});

  final MultiLineString bio;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final style = textTheme.captionMedium.copyWith(
      color: MColorScheme.of(context).onBackgroundVariant,
    );
    return ReadMoreText(
      bio.getOrNull() ?? '',
      style: textTheme.captionRegular,
      trimLines: 3,
      trimMode: TrimMode.Line,
      trimExpandedText: '\nless',
      trimCollapsedText: '\nmore',
      moreStyle: style,
      lessStyle: style,
    );
  }
}

class _ProfileButtons extends StatelessWidget {
  const _ProfileButtons();

  @override
  Widget build(BuildContext context) {
    const shape = RoundedRectangleBorder(borderRadius: Corners.sm);
    final textStyle = MTextTheme.of(context).microMedium;

    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: MPrimaryButton.icon(
              label: 'Edit profile',
              icon: const Icon(MIcons.edit_05),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: textStyle,
                shape: shape,
              ),
            ),
          ),
          Spaces.horizontalLarge,
          Expanded(
            child: MSecondaryButton.icon(
              label: 'Share profile',
              icon: const Icon(MIcons.share),
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                textStyle: textStyle,
                shape: shape,
              ),
            ),
          ),
        ],
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

    if (error != null && page.items.isEmpty) {
      return _EmptyStateWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      );
    }

    if (!isLoading && page.items.isEmpty) {
      return _EmptyStateWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      );
    }

    return _BroadcastList(
      broadcasts: isLoading && page.isEmpty ? fakeBroadcasts : page.items,
      isLoading: isLoading && page.isEmpty,
      hasMore: page.hasMore,
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

    if (error != null && page.items.isEmpty) {
      return _EmptyStateWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      );
    }

    if (!isLoading && page.items.isEmpty) {
      return _EmptyStateWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      );
    }

    return _BroadcastList(
      broadcasts: isLoading && page.isEmpty ? fakeBroadcasts : page.items,
      isLoading: isLoading && page.isEmpty,
      hasMore: page.hasMore,
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  const _FavoritesTab();

  @override
  Widget build(BuildContext context) {
    return _EmptyStateWidget(
      title: 'No favourite broadcasts yet',
      actionTitle: 'View recordings',
      action: () {},
    );
  }
}

class _BroadcastList extends StatelessWidget {
  const _BroadcastList({
    required this.broadcasts,
    required this.hasMore,
    this.isLoading = false,
  });

  final List<Broadcast?> broadcasts;
  final bool hasMore;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const .symmetric(horizontal: 16, vertical: 24),
          sliver: SliverList.separated(
            separatorBuilder: (_, __) => Spaces.verticalLarge,
            itemCount: broadcasts.length,
            itemBuilder: (context, i) => Skeletonizer(
              enabled: isLoading,
              child: _BroadcastListItem(broadcast: broadcasts[i]),
            ),
          ),
        ),
        SliverToBoxAdapter(child: _ListFooter(hasMore: hasMore)),
      ],
    );
  }
}

class _BroadcastListItem extends StatelessWidget {
  const _BroadcastListItem({required this.broadcast});

  final Broadcast? broadcast;

  @override
  Widget build(BuildContext context) {
    if (broadcast == null) {
      // Skeletonizer placeholder — must have same shape as real item.
      return const MRecentlyLiveListTile(
        title: 'Placeholder broadcast title',
        creator: 'Creator name',
      );
    }

    return MRecentlyLiveListTile(
      title: broadcast!.title.getOrCrash(),
      creator: broadcast?.effectiveCreatorName.getOrNull(),
      endTime: broadcast!.endTime,
      imageUrl: broadcast!.imageUrl,
      onTap: () => context.push(R.broadcast(broadcast!.id.getOrCrash())),
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.hasMore});

  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    if (hasMore) return const MLoadingIndicator.box();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: MText(
        "You've reached the end 🎉",
        style: MTextTheme.of(context).captionRegular,
        color: MColorScheme.of(context).onBackgroundVariant,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget({
    required this.actionTitle,
    required this.action,
    this.title,
  });

  final String? title;
  final String actionTitle;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Assets.images.liveForYou.image(height: 120, width: 120),
          MText(
            title ?? 'No broadcasts published yet',
            style: textTheme.captionMedium,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalLarge,
          SizedBox(
            height: 32,
            child: MSecondaryButton.icon(
              label: 'View $actionTitle',
              icon: Icon(MIcons.share, color: colorScheme.onBackground),
              onPressed: action,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                side: BorderSide(color: colorScheme.outlineVariant3),
                foregroundColor: colorScheme.onBackground,
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

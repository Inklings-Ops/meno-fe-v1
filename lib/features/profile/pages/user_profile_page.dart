import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/features/profile/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _kTabBarHeight = 32.0;

class ProfilePage extends WatchingWidget {
  const ProfilePage({required this.userIdStr, super.key});

  final String userIdStr;

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) => getIt.registerLazySingleton(() {
        final uId = Id.fromString(userIdStr);
        return UserProfileManager(userId: uId, http: di<ProfileHttpService>());
      }, onCreated: (instance) => instance.fetch.run()),
    );

    registerHandler(
      handler: (context, errors, cancel) {
        final error = errors?.error;
        if (error == null) return;
        if (error is MenoException) {
          context.showErrorSnackBar(error.message);
        } else {
          context.showErrorSnackBar(error.toString());
        }
        context.pop();
      },
      select: (UserProfileManager manager) => manager.fetch.errors,
    );

    final profile = watchValue((UserProfileManager m) => m.profile);
    final isFetching = watchValue((UserProfileManager m) => m.fetch.isRunning);

    if (isFetching) return _Content.loading();
    if (!isFetching && profile.isEmpty) return const _EmptyPage();
    return _Content(profile: profile);
  }
}

class _Content extends WatchingWidget {
  const _Content({required Profile profile}) : this._(profile: profile);

  const _Content._({required this.profile, this.isLoading = false});

  _Content.loading() : this._(profile: fakeProfile, isLoading: true);

  final Profile profile;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colors.background,
        body: RefreshIndicator(
          onRefresh: () async {},
          child: NestedScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _ProfileAppBar(
                  profile: profile,
                  innerBoxIsScrolled: innerBoxIsScrolled,
                  isLoading: isLoading,
                ),
              ];
            },
            body: isLoading
                ? const SizedBox.shrink()
                : TabBarView(
                    children: [
                      if (isLoading) ...[
                        const SizedBox.shrink(),
                        const SizedBox.shrink(),
                      ] else ...[
                        _RecentBroadcastsTab(creatorId: profile.id),
                        _AllBroadcastsTab(creatorId: profile.id),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar({
    required this.profile,
    required this.innerBoxIsScrolled,
    this.isLoading = false,
  });

  final Profile profile;
  final bool innerBoxIsScrolled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return DynamicSliverAppBar(
      toolbarHeight: kToolbarHeight,
      backgroundColor: colors.background,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      forceElevated: innerBoxIsScrolled,
      elevation: innerBoxIsScrolled ? 1 : 0,
      shadowColor: colors.onBackground.withValues(alpha: 0.08),
      title: Skeletonizer(
        enabled: isLoading,
        child: MText(profile.fullName.getOrCrash()),
      ),
      titleTextStyle: textTheme.bodyMedium,
      leading: MIconButton(
        icon: const Icon(MIcons.chevron_left),
        color: colors.primary,
        onPressed: context.pop,
      ),
      centerTitle: true,
      actions: [
        Skeletonizer(
          enabled: isLoading,
          child: MIconButton(
            icon: const Icon(MIcons.dots_horizontal),
            color: colors.primary,
            onPressed: () => ProfilePageOptionsModal.show(context),
          ),
        ),
        Spaces.horizontalLarge,
      ],
      flexibleSpace: SafeArea(
        bottom: false,
        child: Skeletonizer(
          enabled: isLoading,
          child: ProfileHeaderContent.usersProfile(profile),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const .fromHeight(_kTabBarHeight),
        child: Container(
          color: colors.background,
          height: _kTabBarHeight,
          child: TabBar(
            padding: const .symmetric(horizontal: 16),
            labelStyle: textTheme.captionMedium,
            isScrollable: true,
            tabAlignment: .start,
            labelPadding: const .symmetric(horizontal: 16),
            tabs: const [
              Tab(text: 'Recent broadcasts'),
              Tab(text: 'All broadcasts'),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentBroadcastsTab extends WatchingWidget {
  const _RecentBroadcastsTab({required this.creatorId});

  final Id creatorId;

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery.recentlyLive(creatorId: creatorId),
      );
    });

    return FeedWidget(
      feedSource: feedSource,
      horizontalItemExtent: 148,
      layout: .horizontalList,
      padding: const .symmetric(horizontal: 16),
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

class _AllBroadcastsTab extends WatchingWidget {
  const _AllBroadcastsTab({required this.creatorId});

  final Id creatorId;

  @override
  Widget build(BuildContext context) {
    final feedSource = createOnce(() {
      return BroadcastFeedDataSource(
        http: di<BroadcastHttpService>(),
        socket: di<BroadcastSocketService>(),
        query: BroadcastQuery(creatorId: creatorId),
      );
    });

    return FeedWidget(
      feedSource: feedSource,
      horizontalItemExtent: 148,
      layout: .horizontalList,
      padding: const .symmetric(horizontal: 16),
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

class _EmptyPage extends StatelessWidget {
  const _EmptyPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar.secondary(
        title: 'No Profile',
        centerTitle: true,
        actions: const [Icon(MIcons.dots_horizontal), Spaces.horizontalLarge],
      ),
      body: const MenoEmptyWidget(),
    );
  }
}

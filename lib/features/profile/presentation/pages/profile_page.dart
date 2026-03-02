import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/discover/applications/discover_recently_live_manager.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _kTabBarHeight = 32.0;

typedef _Mgr = ProfileManager;
typedef _RecentBroadcastsMgr = ProfileRecentBroadcastsManager;
typedef _AllBroadcastsMgr = ProfileBroadcastsManager;

class ProfilePage extends WatchingWidget {
  const ProfilePage({required this.userIdStr, super.key});

  final String userIdStr;

  @override
  Widget build(BuildContext context) {
    pushScope(init: _registerDependencies);

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
      select: (_Mgr manager) => manager.fetch.errors,
    );

    final profile = watchValue((ProfileManager m) => m.profile);
    final isFetching = watchValue((ProfileManager m) => m.fetch.isRunning);

    if (isFetching) return _Content.loading();
    if (!isFetching && profile == null) return const _EmptyPage();
    return _Content(profile: profile!);
  }

  void _registerDependencies(GetIt getIt) {
    final userId = Id.fromString(userIdStr);

    getIt.registerLazySingleton(() {
      return ProfileManager(
        userId: userId,
        repository: getIt<IProfileRepository>(),
      );
    }, onCreated: (instance) => instance.fetch.run());

    getIt.registerLazySingleton(() {
      return ProfileRecentBroadcastsManager(
        broadcastFeedSource: di<IBroadcastFeedSource>(),
        userId: userId,
      );
    }, onCreated: (instance) => instance.fetch.run());

    getIt.registerLazySingleton(() {
      return ProfileBroadcastsManager(
        broadcastFeedSource: di<IBroadcastFeedSource>(),
        userId: userId,
      );
    }, onCreated: (instance) => instance.fetch.run());
  }
}

class _Content extends WatchingStatefulWidget {
  const _Content({required Profile profile}) : this._(profile: profile);

  const _Content._({required this.profile, this.isLoading = false});

  _Content.loading() : this._(profile: fakeProfile, isLoading: true);

  final Profile profile;
  final bool isLoading;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final tabController = createOnce(
      () => TabController(length: 2, vsync: this),
    );

    final scrollCtrl = createOnce(() {
      final controller = ScrollController();
      controller.addListener(() {
        if (!controller.hasClients) return;
        final max = controller.position.maxScrollExtent;
        final current = controller.offset;

        // Only fetch more when we're close to the end of the list and
        // if we are on the _AllBroadcastsTab
        if (max - current <= 200 && tabController.index == 1) {
          di<_AllBroadcastsMgr>().fetchMore.run();
        }
      });
      return controller;
    });

    final colors = MColorScheme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: widget.isLoading ? () async {} : onRefresh,
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollCtrl,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _ProfileAppBar(
                profile: widget.profile,
                tabController: tabController,
                innerBoxIsScrolled: innerBoxIsScrolled,
                isLoading: widget.isLoading,
              ),
            ];
          },
          body: widget.isLoading
              ? const SizedBox.shrink()
              : TabBarView(
                  controller: tabController,
                  children: const [_RecentBroadcastsTab(), _AllBroadcastsTab()],
                ),
        ),
      ),
    );
  }

  Future<void> onRefresh() {
    return Future.wait([di<MyProfileManager>().refresh.runAsync()]);
  }
}

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar({
    required this.profile,
    required this.tabController,
    required this.innerBoxIsScrolled,
    this.isLoading = false,
  });

  final Profile profile;
  final TabController tabController;
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
            onPressed: () {},
          ),
        ),
        Spaces.horizontalLarge,
      ],
      flexibleSpace: SafeArea(
        bottom: false,
        child: Skeletonizer(
          enabled: isLoading,
          child: ProfileHeaderContent.othersProfile(profile),
        ),
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
  const _RecentBroadcastsTab();

  @override
  Widget build(BuildContext context) {
    final broadcasts = watchValue((_RecentBroadcastsMgr m) => m.broadcasts);
    final isLoading = watchValue((_RecentBroadcastsMgr m) => m.fetch.isRunning);

    final error = watchValue((DiscoverRecentlyLiveManager m) => m.error);

    if (error != null && !isLoading) {
      return MenoErrorWidget(
        error: error,
        onRetry: di<_RecentBroadcastsMgr>().fetch.runAsync,
      );
    }

    if (broadcasts.isEmpty && !isLoading) {
      return ProfileEmptyBroadcastsListWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      );
    }

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        padding: const .all(Insets.lg),
        separatorBuilder: (_, __) => Spaces.verticalLarge,
        itemCount: broadcasts.length,
        itemBuilder: (context, index) {
          final broadcast = broadcasts[index];
          if (broadcast == null) return const SizedBox.shrink();
          return Skeletonizer(
            enabled: isLoading,
            child: MRecentlyLiveListTile(
              title: broadcast.title.getOrCrash(),
              creator: broadcast.effectiveCreatorName.getOrNull(),
              endTime: broadcast.endTime,
              imageUrl: broadcast.imageUrl,
              onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
            ),
          );
        },
      ),
    );
  }
}

class _AllBroadcastsTab extends WatchingWidget {
  const _AllBroadcastsTab();

  @override
  Widget build(BuildContext context) {
    final page = watchValue((_AllBroadcastsMgr m) => m.pagedList);
    final isFetching = watchValue((_AllBroadcastsMgr m) => m.fetch.isRunning);

    final error = watchValue((DiscoverRecentlyLiveManager m) => m.error);

    return ProfileBroadcastListWidget(
      page: page,
      emptyListWidgetBuilder: (context) => ProfileEmptyBroadcastsListWidget(
        title: 'No broadcasts published yet',
        actionTitle: 'View recordings',
        action: () {},
      ),
      errorWidgetBuilder: (context) => MenoErrorWidget(
        error: error,
        onRetry: di<_AllBroadcastsMgr>().fetch.runAsync,
      ),
      isLoading: isFetching && page.isEmpty,
      hasError: error != null,
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

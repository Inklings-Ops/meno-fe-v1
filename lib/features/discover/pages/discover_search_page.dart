import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/model/entities/broadcast.dart';
import 'package:meno/features/broadcast/services/broadcast_http_service.dart';
import 'package:meno/features/discover/discover.dart';
import 'package:meno/features/profile/services/profile_http_service.dart';
import 'package:meno/features/profile/widgets/profile_card.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverSearchPage extends WatchingWidget {
  const DiscoverSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) {
        getIt.registerLazySingleton<DiscoverSearchManager>(
          () => DiscoverSearchManager(
            broadcastHttp: di<BroadcastHttpService>(),
            profileHttp: di<ProfileHttpService>(),
            local: di<DiscoverLocalService>(),
            userId: di<UserManager>().currentUserId.value,
          ),
          onCreated: (instance) => instance.initialize.run(),
        );
      },
    );

    return const _SearchView(key: Key('discover-search-view'));
  }
}

class _SearchView extends WatchingWidget {
  const _SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<DiscoverSearchManager>();

    final scrollController = createOnce(() {
      final controller = ScrollController();
      controller.addListener(() {
        if (!controller.hasClients) return;
        final max = controller.position.maxScrollExtent;
        final current = controller.position.pixels;
        if (max - current <= 120.0) manager.fetchMore.run();
      });
      return controller;
    });

    return MScaffold(
      padding: .zero,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const SizedBox.shrink(),
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: DiscoverSearchBar(
            padding: const .fromLTRB(16, 8, 16, 4),
            showCancelButton: true,
            onSubmitted: manager.search.run,
          ),
        ),
      ),
      body: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: const [_SearchBody(key: Key('discover-search-body'))],
      ),
    );
  }
}

class _SearchBody extends WatchingWidget {
  const _SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    final query = watchValue((DiscoverSearchManager m) => m.query);

    if (query.trim().isEmpty) return const _RecentSearchesWidget();

    return const _SearchResults(key: Key('discover-search-results'));
  }
}

class _RecentSearchesWidget extends WatchingWidget {
  const _RecentSearchesWidget();

  @override
  Widget build(BuildContext context) {
    final manager = di<DiscoverSearchManager>();

    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final recents = watchValue((DiscoverSearchManager m) => m.recentSearches);

    if (recents.isEmpty) return const SliverToBoxAdapter(child: SizedBox());

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: MText('Recent searches', style: textTheme.subheadingBold),
          ),
        ),
        SliverList.separated(
          itemCount: recents.length,
          separatorBuilder: (_, __) => const SizedBox(height: 24),
          itemBuilder: (context, i) {
            final term = recents[i];
            return ListTile(
              visualDensity: .compact,
              minTileHeight: 24,
              contentPadding: const .symmetric(horizontal: 16),
              iconColor: colors.inActive,
              leading: const Icon(MIcons.clock_rewind, size: 20),
              horizontalTitleGap: 8,
              title: MText(term, style: textTheme.bodyRegular),
              trailing: MIconButton(
                onPressed: () => manager.removeRecentSearch.run(term),
                color: colors.onBackground,
                icon: const Icon(MIcons.x_close),
              ),
              onTap: () => manager.search.run(term),
            );
          },
        ),
        SliverToBoxAdapter(
          child: Center(
            child: MTextButton(
              label: 'Clear recent searches',
              onPressed: manager.clearRecentSearches.run,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchResults extends WatchingWidget {
  const _SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final isFetchingMore = watchValue(
      (DiscoverSearchManager m) => m.fetchMore.isRunning,
    );
    final hasMore = watchValue((DiscoverSearchManager m) => m.hasMore);
    final results = watchValue((DiscoverSearchManager m) => m.results);

    if (results.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _NoResultsWidget(),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 159.50 / 192,
            ),
            itemCount: results.length,
            itemBuilder: (context, i) => switch (results[i]) {
              BroadcastResult(:final broadcast) => _BroadcastCard(broadcast),
              ProfileResult(:final proxy) => ProfileCard(
                proxy: proxy,
                onTap: () => context.push(R.profile(proxy.id.getOrCrash())),
              ),
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Spaces.verticalXLarge,
              MenoPagedLoadingIndicator(
                isLoading: isFetchingMore,
                hasMore: hasMore,
              ),
              Spaces.verticalXLarge,
            ],
          ),
        ),
      ],
    );
  }
}

class _BroadcastCard extends StatelessWidget {
  const _BroadcastCard(this.broadcast);

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    // Now Live Cards
    if (broadcast.isActive) {
      return BroadcastCard.nLive(broadcast, onTap: () {});
    }

    // Recently Live Cards
    return BroadcastCard.rLive(
      broadcast,
      onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
    );
  }
}

class _NoResultsWidget extends StatelessWidget {
  const _NoResultsWidget();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(height: 152, width: 152),
          Spaces.verticalXLarge,
          MText(
            'No Results',
            style: textTheme.heading3Bold,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalMicro,
          MText(
            'Try a new search',
            style: textTheme.bodyRegular,
            color: colors.inActiveContainer,
          ),
        ],
      ),
    );
  }
}

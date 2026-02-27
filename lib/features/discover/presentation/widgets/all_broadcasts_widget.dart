import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/features/discover/applications/applications.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllBroadcastsWidget extends StatelessWidget {
  const AllBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spaces.verticalXLarge,
          _NowLiveSection(key: Key('DiscoverNowLiveSection')),
          Spaces.verticalXXLarge,
          _RecentlyLiveSection(key: Key('DiscoverRecentlyLiveSection')),
          Spaces.verticalXXLarge,
        ],
      ),
    );
  }
}

class _NowLiveSection extends WatchingWidget {
  const _NowLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final nowLiveBroadcasts = watchValue(
      (DiscoverNowLiveManager m) => m.broadcasts,
    );

    final isLoading = watchValue(
      (DiscoverNowLiveManager m) => m.initialize.isRunning,
    );

    return _Grid(
      title: 'Now Live',
      broadcasts: nowLiveBroadcasts.items,
      onSeeAll: di<DiscoverManager>().goToNowLive,
      loading: isLoading,
      itemBuilder: (_, broadcast) => LiveBroadcastCard(broadcast: broadcast),
      emptyListBuilder: (context) => const EmptyListWidget(),
    );
  }
}

class _RecentlyLiveSection extends WatchingWidget {
  const _RecentlyLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final recentlyLiveBroadcasts = watchValue(
      (DiscoverRecentlyLiveManager m) => m.broadcasts,
    );

    final isLoading = watchValue(
      (DiscoverRecentlyLiveManager m) => m.initialize.isRunning,
    );

    return _Grid(
      title: 'Recently Live',
      broadcasts: recentlyLiveBroadcasts.items,
      onSeeAll: di<DiscoverManager>().goToRecentlyLive,
      loading: isLoading,
      itemBuilder: (_, broadcast) => MCard.recentlyLive(
        title: broadcast.title.getOrCrash(),
        imageUrl: broadcast.imageUrl,
        host: broadcast.effectiveCreatorName.getOrCrash(),
        onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
      ),
      emptyListBuilder: (context) => const EmptyListWidget(),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.title,
    required this.broadcasts,
    required this.itemBuilder,
    required this.emptyListBuilder,
    required this.onSeeAll,
    this.loading = false,
  });

  final String title;
  final List<Broadcast?> broadcasts;
  final Widget Function(BuildContext context, Broadcast broadcast) itemBuilder;
  final Widget Function(BuildContext context) emptyListBuilder;
  final VoidCallback onSeeAll;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final isEmpty = broadcasts.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(title: title, onSeeAll: isEmpty ? null : onSeeAll),
        Spaces.verticalXLarge,
        if (isEmpty) _buildEmptyWidget(context) else _buildGrid(context),
      ],
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return SizedBox(height: 376, child: emptyListBuilder(context));
  }

  Widget _buildGrid(BuildContext context) {
    return LimitedBox(
      maxHeight: 376,
      child: Skeletonizer(
        enabled: loading,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          primary: false,
          itemCount: broadcasts.length,
          itemBuilder: (ctx, i) => itemBuilder(ctx, broadcasts[i]!),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          MText(title, style: textTheme.subheadingBold),
          if (onSeeAll != null)
            InkWell(
              onTap: onSeeAll,
              child: MText(
                'See all',
                style: textTheme.microMedium,
                color: colors.primary,
              ),
            ),
        ],
      ),
    );
  }
}

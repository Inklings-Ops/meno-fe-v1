import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/discover/applications/discover_recently_live_manager.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

typedef _Mgr = DiscoverRecentlyLiveManager;

class RecentlyLiveBroadcastsWidget extends WatchingWidget {
  const RecentlyLiveBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<_Mgr>();

    final scrollController = createOnce(() {
      final controller = ScrollController();
      void onScroll() {
        if (!controller.hasClients) return;

        final maxScroll = controller.position.maxScrollExtent;
        final currentScroll = controller.position.pixels;
        const distance = 120.0; // trigger distance

        if (maxScroll - currentScroll <= distance) manager.fetchMore.run();
      }

      controller.addListener(onScroll);
      return controller;
    });

    final broadcasts = watchValue((_Mgr m) => m.broadcasts);
    final error = watchValue((_Mgr m) => m.error);
    final isLoading = watchValue((_Mgr m) => m.isLoading);
    final isFetchingMore = watchValue((_Mgr m) => m.fetchMore.isRunning);

    if (isLoading) return Skeletonizer(child: _List(fakeBroadcasts));

    if (error != null && broadcasts.items.isEmpty && !isLoading) {
      return MenoErrorWidget(error: error, onRetry: manager.refresh.runAsync);
    }

    if (broadcasts.items.isEmpty && !isLoading) return const EmptyListWidget();

    return RefreshIndicator(
      onRefresh: manager.refresh.runAsync,
      child: _List(
        broadcasts.items,
        controller: scrollController,
        isLoadingMore: isFetchingMore,
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List(this.broadcasts, {this.controller, this.isLoadingMore = false});

  final List<Broadcast?> broadcasts;
  final ScrollController? controller;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 159.50 / 176,
      ),
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: isLoadingMore ? broadcasts.length + 1 : broadcasts.length,
      itemBuilder: (context, index) {
        if (index == broadcasts.length) {
          return Skeletonizer(
            child: MCard.recentlyLive(
              title: BoneMock.title,
              host: BoneMock.fullName,
            ),
          );
        }

        final broadcast = broadcasts[index]!;
        return MCard.recentlyLive(
          title: broadcast.title.getOrCrash(),
          imageUrl: broadcast.imageUrl,
          host: broadcast.effectiveCreatorName.getOrNull(),
          onTap: () => context.push(R.broadcast(broadcast.id.getOrCrash())),
        );
      },
    );
  }
}

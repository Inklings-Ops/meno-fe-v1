import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecentlyLiveListWidget extends WatchingStatefulWidget {
  const RecentlyLiveListWidget({super.key});

  @override
  State<RecentlyLiveListWidget> createState() => _RecentlyLiveListWidgetState();
}

class _RecentlyLiveListWidgetState extends State<RecentlyLiveListWidget> {
  final scrollController = ScrollController();

  Future<void> listener() async {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    const delta = 120.0;
    if (maxScroll - currentScroll <= delta) {
      final manager = di<BroadcastsManager>();
      final currentQuery = di<BroadcastQuery>();
      manager.loadBroadcasts.run(
        currentQuery.copyWith(pagination: currentQuery.pagination.next()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(listener);
  }

  @override
  void dispose() {
    scrollController.removeListener(listener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagedList = watchValue((BroadcastsManager m) => m.broadcasts);
    final isLoading = watchValue(
      (BroadcastsManager m) => m.loadBroadcasts.isRunning,
    );
    final errors = watchValue((BroadcastsManager m) => m.loadBroadcasts.errors);

    if (isLoading && pagedList.items.isEmpty) {
      return _ListWidget(fakeBroadcasts, isLoading: true);
    }

    if (errors != null) return MenoErrorWidget(error: errors.error);

    if (pagedList.items.isEmpty) return const EmptyListWidget();

    return _ListWidget(
      pagedList.items,
      scrollController: scrollController,
      moreInProgress: isLoading && pagedList.items.isNotEmpty,
    );
  }
}

class _ListWidget extends StatelessWidget {
  const _ListWidget(
    this.broadcasts, {
    this.scrollController,
    this.isLoading = false,
    this.moreInProgress = false,
  });

  final List<Broadcast?> broadcasts;
  final ScrollController? scrollController;
  final bool isLoading;
  final bool moreInProgress;

  @override
  Widget build(BuildContext context) {
    if (broadcasts.isEmpty) return const EmptyListWidget();

    final itemCount = broadcasts.length + (moreInProgress ? 1 : 0);

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 32),
        itemCount: itemCount,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        separatorBuilder: (context, index) => const SizedBox(height: Insets.lg),
        itemBuilder: (context, index) {
          if (index == broadcasts.length) {
            if (moreInProgress) {
              return Skeletonizer(
                child: MRecentlyLiveListTile(
                  title: BoneMock.title,
                  creator: BoneMock.fullName,
                  endTime: DateTime.now(),
                ),
              );
            }

            return const SizedBox.shrink();
          }

          final broadcast = broadcasts[index]!;
          return MRecentlyLiveListTile(
            title: broadcast.title.getOrCrash(),
            endTime: broadcast.endTime,
            imageUrl: broadcast.imageUrl,
            creator: broadcast.effectiveCreatorName.getOrNull(),
            onTap: () => context.push('${R.broadcasts}/${broadcast.id}'),
          );
        },
      ),
    );
  }
}

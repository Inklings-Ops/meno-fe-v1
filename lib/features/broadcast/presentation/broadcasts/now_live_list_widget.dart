import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NowLiveListWidget extends WatchingStatefulWidget {
  const NowLiveListWidget({super.key});

  @override
  State<NowLiveListWidget> createState() => _NowLiveListWidgetState();
}

class _NowLiveListWidgetState extends State<NowLiveListWidget> {
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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Insets.sm,
          mainAxisSpacing: Insets.lg,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == broadcasts.length) {
            if (moreInProgress) {
              return Skeletonizer(
                child: MCard.live(
                  title: BoneMock.title,
                  host: BoneMock.fullName,
                ),
              );
            }

            return const SizedBox.shrink();
          }

          final broadcast = broadcasts[index]!;
          return LiveBroadcastCard(broadcast: broadcast);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeedWidget<TItem> extends WatchingWidget {
  const FeedWidget({
    required this.feedSource,
    required this.itemBuilder,
    this.layout = FeedLayout.verticalList,
    this.emptyWidget = const MenoEmptyWidget(),
    this.gridCrossAxisCount = 2,
    this.gridChildAspectRatio = 1.0,
    this.gridMainAxisSpacing = 12.0,
    this.gridCrossAxisSpacing = 12.0,
    this.horizontalItemExtent,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    super.key,
  });

  /// Data source for the feed. The widget listens to its notifiers and commands
  final PagedFeedDataSource<TItem> feedSource;

  /// Builds each item in the feed. The feed widget handles fetching items from
  final Widget Function(BuildContext context, TItem item) itemBuilder;

  /// Dictates how items are arranged inside [FeedWidget].
  final FeedLayout layout;

  /// Grid-only: number of columns. Default 2.
  final int gridCrossAxisCount;

  /// Grid-only: child aspect ratio. Default 1.0.
  final double gridChildAspectRatio;

  /// Grid-only: vertical spacing. Default 12.
  final double gridMainAxisSpacing;

  /// Grid-only: horizontal spacing. Default 12.
  final double gridCrossAxisSpacing;

  /// Horizontal list only: fixed width for each item. If null, items size
  /// themselves.
  final double? horizontalItemExtent;

  /// Padding around the list/grid.
  final EdgeInsetsGeometry? padding;

  /// Pass `true` when embedding inside another scrollable (e.g. a Column
  /// inside SingleChildScrollView or NestedScrollView inner body).
  final bool shrinkWrap;

  /// Override scroll physics. If null, Flutter chooses platform defaults.
  final ScrollPhysics? physics;

  /// Empty state placeholder widget.
  final Widget emptyWidget;

  @override
  Widget build(BuildContext context) {
    // Trigger the first fetch exactly once.
    callOnce((_) => feedSource.updateDataCommand.run());

    // Show errors via snack-bar (does not cause rebuild).
    registerHandler(
      target: feedSource.commandErrors,
      handler: (context, error, _) {
        if (error is CommandError) {
          final inner = error.error;
          if (inner is MenoException) {
            context.showErrorSnackBar(inner.message);
          } else {
            context.showErrorSnackBar(inner.toString());
          }
        }
      },
    );

    // Watch both notifiers — ordering is stable.
    final itemCount = watch(feedSource.itemCount).value;
    final isFetching = watch(feedSource.isFetching).value;
    final isInitialLoading = !feedSource.updateWasCalled && isFetching;

    if (feedSource.commandErrors.value != null && itemCount == 0) {
      return MenoErrorWidget(
        error: feedSource.commandErrors.value,
        onRetry: feedSource.updateDataCommand.runAsync,
      );
    }

    if (itemCount == 0 && feedSource.updateWasCalled) return emptyWidget;

    // itemCount and pagination are fully controlled by BroadcastQuery.
    // If the query specifies size: 20 and totalPages == 1, hasNextPage is
    // false and no footer/pagination command ever fires — no presentation
    // layer cap needed.
    final listItemCount = itemCount + (isFetching ? 1 : 0);

    return switch (layout) {
      FeedLayout.horizontalList => _HorizontalList(
        feedSource: feedSource,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        isInitialLoading: isInitialLoading,
        itemExtent: horizontalItemExtent,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
      ),
      FeedLayout.verticalList => _VerticalList(
        feedSource: feedSource,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        isInitialLoading: isInitialLoading,
        isFetching: isFetching,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
      ),
      FeedLayout.verticalGrid => _GridList(
        feedSource: feedSource,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        listItemCount: listItemCount,
        isFetching: isFetching,
        crossAxisCount: gridCrossAxisCount,
        childAspectRatio: gridChildAspectRatio,
        mainAxisSpacing: gridMainAxisSpacing,
        crossAxisSpacing: gridCrossAxisSpacing,
        isInitialLoading: isInitialLoading,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        scrollDirection: .vertical,
      ),
      FeedLayout.horizontalGrid => _GridList(
        feedSource: feedSource,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        listItemCount: listItemCount,
        isFetching: isFetching,
        crossAxisCount: gridCrossAxisCount,
        childAspectRatio: gridChildAspectRatio,
        mainAxisSpacing: gridMainAxisSpacing,
        crossAxisSpacing: gridCrossAxisSpacing,
        isInitialLoading: isInitialLoading,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        scrollDirection: .horizontal,
      ),
    };
  }
}

/// Single-row horizontal [ListView]. No pull-to-refresh, no pagination footer.
class _HorizontalList<TItem> extends StatelessWidget {
  const _HorizontalList({
    required this.feedSource,
    required this.itemBuilder,
    required this.itemCount,
    required this.isInitialLoading,
    this.itemExtent,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  final PagedFeedDataSource<TItem> feedSource;
  final Widget Function(BuildContext, TItem) itemBuilder;
  final int itemCount;
  final double? itemExtent;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool isInitialLoading;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: feedSource.updateDataCommand.runAsync,
      child: ListView.separated(
        scrollDirection: .horizontal,
        clipBehavior: .none,
        padding: padding ?? const .symmetric(horizontal: Insets.lg),
        shrinkWrap: shrinkWrap,
        physics: physics,
        separatorBuilder: (context, i) => const SizedBox(width: 24),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final item = feedSource.getItemAtIndex(index);
          return Skeletonizer(
            enabled: isInitialLoading,
            child: itemBuilder(context, item),
          );
        },
      ),
    );
  }
}

/// Vertical scrolling [ListView] with pull-to-refresh and pagination footer.
class _VerticalList<TItem> extends StatelessWidget {
  const _VerticalList({
    required this.feedSource,
    required this.itemBuilder,
    required this.itemCount,
    required this.isFetching,
    required this.isInitialLoading,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  final PagedFeedDataSource<TItem> feedSource;
  final Widget Function(BuildContext, TItem) itemBuilder;
  final int itemCount;
  final bool isFetching;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool isInitialLoading;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: feedSource.updateDataCommand.runAsync,
      child: CustomScrollView(
        shrinkWrap: shrinkWrap,
        physics: physics,
        slivers: [
          SliverPadding(
            padding: padding ?? EdgeInsets.zero,
            sliver: SliverList.separated(
              itemCount: itemCount,
              separatorBuilder: (_, __) => Spaces.verticalLarge,
              itemBuilder: (context, index) {
                final item = feedSource.getItemAtIndex(index);
                return Skeletonizer(
                  enabled: isInitialLoading,
                  child: itemBuilder(context, item),
                );
              },
            ),
          ),
          if (!isInitialLoading) ...[
            SliverToBoxAdapter(
              child: MenoPagedLoadingIndicator(
                isLoading: isFetching,
                hasMore: feedSource.hasNextPage,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Two-column (or N-column) [GridView] with pagination footer.
class _GridList<TItem> extends StatelessWidget {
  const _GridList({
    required this.feedSource,
    required this.itemBuilder,
    required this.itemCount,
    required this.listItemCount,
    required this.isFetching,
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.isInitialLoading,
    required this.scrollDirection,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  final PagedFeedDataSource<TItem> feedSource;
  final Widget Function(BuildContext, TItem) itemBuilder;
  final int itemCount;
  final int listItemCount;
  final bool isFetching;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool isInitialLoading;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: feedSource.updateDataCommand.runAsync,
      child: CustomScrollView(
        scrollDirection: scrollDirection,
        shrinkWrap: shrinkWrap,
        physics: physics,
        slivers: [
          SliverPadding(
            padding: padding ?? .zero,
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = feedSource.getItemAtIndex(index);
                return Skeletonizer(
                  enabled: isInitialLoading,
                  child: itemBuilder(context, item),
                );
              }, childCount: itemCount),
            ),
          ),
          SliverToBoxAdapter(
            child: MenoPagedLoadingIndicator(
              isLoading: isFetching,
              hasMore: feedSource.hasNextPage,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dictates how items are arranged inside [FeedWidget].
enum FeedLayout {
  /// Vertical [ListView] — default. Good for profile broadcast tiles.
  verticalList,

  /// Horizontal single-row [ListView] — good for home page preview strips.
  horizontalList,

  /// [GridView] with a fixed cross-axis count — good for Discover.
  verticalGrid,
  horizontalGrid,
}

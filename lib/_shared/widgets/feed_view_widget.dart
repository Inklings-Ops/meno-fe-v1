import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FeedViewWidget<TItem> extends WatchingWidget {
  const FeedViewWidget({
    required this.feedSource,
    required this.itemBuilder,
    required this.skeleton,
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

  final PagedFeedDataSource<TItem> feedSource;
  final Widget Function(BuildContext context, TItem item) itemBuilder;

  /// Called while the very first fetch is in-flight (no data yet).
  /// Return a skeleton/shimmer widget that matches the item shape.
  final Widget Function(BuildContext context) skeleton;

  /// Dictates how items are arranged inside [FeedViewWidget].
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
    // Watch both notifiers — ordering is stable.
    final itemCount = watch(feedSource.itemCount).value;
    final isFetching = watch(feedSource.isFetching).value;

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

    if (feedSource.commandErrors.value != null && itemCount == 0) {
      return MenoErrorWidget(
        error: feedSource.commandErrors.value,
        onRetry: feedSource.updateDataCommand.runAsync,
      );
    }

    if (!feedSource.updateWasCalled && isFetching) return skeleton(context);

    if (itemCount == 0 && feedSource.updateWasCalled) return emptyWidget;

    // itemCount and pagination are fully controlled by BroadcastQuery.
    // If the query specifies size: 20 and totalPages == 1, hasNextPage is
    // false and no footer/pagination command ever fires — no presentation
    // layer cap needed.
    final listItemCount = itemCount + (isFetching ? 1 : 0);

    return switch (layout) {
      FeedLayout.verticalList => _VerticalList(
        feedSource: feedSource,
        itemBuilder: itemBuilder,
        itemCount: listItemCount,
        isFetching: isFetching,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
      ),
      FeedLayout.horizontalList => _HorizontalList(
        feedSource: feedSource,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        itemExtent: horizontalItemExtent,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
      ),
      FeedLayout.grid => _GridList(
        feedSource: feedSource,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        listItemCount: listItemCount,
        isFetching: isFetching,
        crossAxisCount: gridCrossAxisCount,
        childAspectRatio: gridChildAspectRatio,
        mainAxisSpacing: gridMainAxisSpacing,
        crossAxisSpacing: gridCrossAxisSpacing,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: .horizontal,
      padding: padding ?? .zero,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemExtent: itemExtent,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final item = feedSource.getItemAtIndex(index);
        return itemBuilder(context, item);
      },
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => feedSource.updateDataCommand.runAsync(),
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
                return itemBuilder(context, item);
              },
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => feedSource.updateDataCommand.runAsync(),
      child: CustomScrollView(
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
                return itemBuilder(context, item);
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

/// Dictates how items are arranged inside [FeedViewWidget].
enum FeedLayout {
  /// Vertical [ListView] — default. Good for profile broadcast tiles.
  verticalList,

  /// Horizontal single-row [ListView] — good for home page preview strips.
  horizontalList,

  /// [GridView] with a fixed cross-axis count — good for Discover.
  grid,
}

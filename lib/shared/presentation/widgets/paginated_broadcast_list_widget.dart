import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Configuration for paginated broadcast list
class BroadcastListConfig {
  const BroadcastListConfig({
    required this.itemBuilder,
    required this.skeletonBuilder,
    this.layout = BroadcastListLayout.list,
    this.padding = const EdgeInsets.fromLTRB(16, 30, 16, 32),
    this.scrollController,
  });

  final Widget Function(BuildContext context, Broadcast broadcast) itemBuilder;
  final Widget Function() skeletonBuilder;
  final BroadcastListLayout layout;
  final EdgeInsets padding;
  final ScrollController? scrollController;
}

enum BroadcastListLayout { list, grid }

/// Reusable paginated broadcast list widget
///
/// Handles:
/// - Loading states
/// - Empty states
/// - Error states
/// - Infinite scroll
/// - Pull to refresh
class PaginatedBroadcastList extends WatchingStatefulWidget {
  const PaginatedBroadcastList({required this.config, super.key});

  final BroadcastListConfig config;

  @override
  State<PaginatedBroadcastList> createState() => _PaginatedBroadcastListState();
}

class _PaginatedBroadcastListState extends State<PaginatedBroadcastList> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.config.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.config.scrollController == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const triggerDistance = 120.0;

    // Trigger load more when near bottom
    if (maxScroll - currentScroll <= triggerDistance) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoadingMore) return;

    final manager = di<BroadcastsManager>();
    if (!manager.canFetchMore) return;

    setState(() => _isLoadingMore = true);
    manager.fetchMore.run();
    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _onRefresh() async {
    final manager = di<BroadcastsManager>();
    await manager.refresh.runAsync();
  }

  @override
  Widget build(BuildContext context) {
    final pagedList = watchValue((BroadcastsManager m) => m.broadcasts);
    final isLoading = watchValue((BroadcastsManager m) => m.fetch.isRunning);
    final error = watchValue((BroadcastsManager m) => m.fetch.errors);

    // Initial loading state
    if (isLoading && pagedList.items.isEmpty) {
      return _buildSkeletonList();
    }

    // Error state
    if (error != null && pagedList.items.isEmpty) {
      return _buildErrorState(error.error);
    }

    // Empty state
    if (pagedList.items.isEmpty) {
      return const MenoEmptyWidget();
    }

    // Content with refresh
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: _buildContent(
        broadcasts: pagedList.items,
        isLoadingMore: _isLoadingMore,
      ),
    );
  }

  Widget _buildSkeletonList() {
    return Skeletonizer(
      child: _buildListWidget(
        broadcasts: fakeBroadcasts,
        showLoadingIndicator: false,
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return MenoErrorWidget(
      error: error,
      onRetry: () async {
        final manager = di<BroadcastsManager>();
        await manager.refresh.runAsync();
      },
    );
  }

  Widget _buildContent({
    required List<Broadcast?> broadcasts,
    required bool isLoadingMore,
  }) {
    return _buildListWidget(
      broadcasts: broadcasts,
      showLoadingIndicator: isLoadingMore,
    );
  }

  Widget _buildListWidget({
    required List<Broadcast?> broadcasts,
    required bool showLoadingIndicator,
  }) {
    final itemCount = broadcasts.length + (showLoadingIndicator ? 1 : 0);

    return switch (widget.config.layout) {
      BroadcastListLayout.grid => _buildGridView(
        broadcasts: broadcasts,
        itemCount: itemCount,
        showLoadingIndicator: showLoadingIndicator,
      ),
      BroadcastListLayout.list => _buildListView(
        broadcasts: broadcasts,
        itemCount: itemCount,
        showLoadingIndicator: showLoadingIndicator,
      ),
    };
  }

  Widget _buildGridView({
    required List<Broadcast?> broadcasts,
    required int itemCount,
    required bool showLoadingIndicator,
  }) {
    return GridView.builder(
      controller: _scrollController,
      padding: widget.config.padding,
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Insets.sm,
        mainAxisSpacing: Insets.lg,
        childAspectRatio: 0.8, // Adjust based on card design
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == broadcasts.length) {
          return _buildLoadingIndicator();
        }

        final broadcast = broadcasts[index];
        if (broadcast == null) return const SizedBox.shrink();

        return widget.config.itemBuilder(context, broadcast);
      },
    );
  }

  Widget _buildListView({
    required List<Broadcast?> broadcasts,
    required int itemCount,
    required bool showLoadingIndicator,
  }) {
    return ListView.separated(
      controller: _scrollController,
      padding: widget.config.padding,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: Insets.lg),
      itemBuilder: (context, index) {
        if (index == broadcasts.length) {
          return _buildLoadingIndicator();
        }

        final broadcast = broadcasts[index];
        if (broadcast == null) return const SizedBox.shrink();

        return widget.config.itemBuilder(context, broadcast);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Skeletonizer(child: widget.config.skeletonBuilder());
  }
}

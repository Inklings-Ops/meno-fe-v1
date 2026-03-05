import 'package:meno/_shared/manager/feed_data_source.dart';
import 'package:meno/_shared/model/broadcast_query.dart';
import 'package:meno/features/broadcast/model/model.dart';
import 'package:meno/features/broadcast/services/broadcast_http_service.dart';

/// Concrete [PagedFeedDataSource] for [Broadcast] items.
class BroadcastFeedDataSource extends PagedFeedDataSource<Broadcast?> {
  BroadcastFeedDataSource({
    required BroadcastHttpDataSource http,
    required BroadcastQuery initialQuery,
  }) : _http = http,
       _query = initialQuery {
    // Wire the combined isFetching notifier immediately.
    initFetchingSync();
  }

  final BroadcastHttpDataSource _http;
  BroadcastQuery _query;

  @override
  bool itemsAreEqual(Broadcast? a, Broadcast? b) => a?.id == b?.id;

  @override
  Future<void> updateFeedData() async {
    // Always restart from page 1 on a refresh.
    _query = _query.resetPage();

    final result = await _http.getBroadcasts(_query);

    // Replace list entirely (no stale items from previous session/user).
    items.clear();
    items.addAll(result.items);

    updatePaginationState(
      currentPage: result.currentPage,
      totalPages: result.totalPages,
    );
  }

  @override
  Future<void> requestNextPage() async {
    if (!hasNextPage) return;

    _query = _query.nextPage();

    final result = await _http.getBroadcasts(_query);

    // Deduplicate before appending so rapid calls don't double-insert.
    for (final item in result.items) {
      if (!items.any((existing) => itemsAreEqual(existing, item))) {
        items.add(item);
      }
    }

    updatePaginationState(
      currentPage: result.currentPage,
      totalPages: result.totalPages,
    );
  }

  /// Prepend a newly-ended broadcast (from socket) without re-fetching.
  ///
  /// Idempotent — does nothing if the broadcast is already in the list.
  void prependFromSocket(Broadcast broadcast) {
    if (items.any((b) => b?.id == broadcast.id)) return;
    addItemAtStart(broadcast);
  }

  /// Remove a broadcast by id (now-live feeds use this when a broadcast ends).
  void removeById(String broadcastId) {
    items.removeWhere((b) => b?.id.getOrNull() == broadcastId);
    refreshItemCount();
  }

  // -------------------------------------------------------------------------
  // Filter / query update
  // -------------------------------------------------------------------------

  /// Replace the query and immediately refresh from page 1.
  ///
  /// Typical use-case: keyword search on the Discover page.
  void updateQuery(BroadcastQuery newQuery) {
    _query = newQuery.resetPage();
    updateDataCommand.run();
  }

  /// Convenience: update only the keyword filter and refresh.
  void updateKeywords(String? keywords) {
    updateQuery(_query.updateKeywords(keywords));
  }

  /// Read-only access to the current query (useful for debugging / tests).
  BroadcastQuery get currentQuery => _query;
}

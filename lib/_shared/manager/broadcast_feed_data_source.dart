import 'dart:async';

import 'package:meno/_shared/manager/feed_data_source.dart';
import 'package:meno/_shared/model/broadcast_query.dart';
import 'package:meno/features/broadcast/broadcast.dart';

/// Concrete [PagedFeedDataSource] for [Broadcast] items.
///
/// Socket behaviour is driven entirely by [BroadcastsType] on the query:
///
/// | Type          | New Broadcast    | Ended Broadcast          |
/// |---------------|------------------|--------------------------|
/// | nowLive       | prepend          | remove                   |
/// | forYou        | prepend          | remove                   |
/// | recentlyLive  | —                | prepend (ended → recent) |
/// | null / other  | —                | —                        |
///
/// Pass socket to opt into real-time updates. Omit it (or pass null) for
/// purely HTTP-backed feeds (profile, search, etc.) that need no socket.
class BroadcastFeedDataSource extends PagedFeedDataSource<Broadcast?> {
  BroadcastFeedDataSource({
    required BroadcastHttpService http,
    required BroadcastQuery query,
    BroadcastSocketService? socket,
    super.fetchMoreEnabled = true,
  }) : _http = http,
       _query = query {
    // Wire the combined isFetching notifier immediately.
    _bindSocketService(socket);
  }

  final BroadcastHttpService _http;

  BroadcastQuery _query;
  StreamSubscription<Broadcast>? _newBroadcastSub;
  StreamSubscription<EndedBroadcast>? _endedBroadcastSub;

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

  void _bindSocketService(BroadcastSocketService? socket) {
    final type = _query.type;
    if (socket == null || type == null) return;
    switch (type) {
      case BroadcastsType.forYou:
      case BroadcastsType.nowLive:
        _newBroadcastSub = socket.onNewBroadcast.listen(_onNewBroadcast);
        _endedBroadcastSub = socket.onEndedBroadcast.listen(_onEndedBroadcast);
      case BroadcastsType.recentlyLive:
        _endedBroadcastSub = socket.onEndedBroadcast.listen(_onRecentBroadcast);
    }
  }

  /// Prepend a newly-ended broadcast (from socket) without re-fetching.
  ///
  /// Idempotent — does nothing if the broadcast is already in the list.
  void _onNewBroadcast(Broadcast broadcast) {
    if (items.any((b) => b?.id == broadcast.id)) return;
    addItemAtStart(broadcast);
  }

  /// Remove a broadcast by id (now-live feeds use this when a broadcast ends).
  void _onEndedBroadcast(EndedBroadcast ended) {
    final index = items.indexWhere((b) => b?.id == ended.details.id);
    if (index == -1) return;
    removeObject(items[index]);
    refreshItemCount();
  }

  /// When a broadcast ends it moves from now-live → recently-live.
  /// Prepend it to the recently-live feed immediately without re-fetching.
  void _onRecentBroadcast(EndedBroadcast ended) {
    final broadcast = ended.details;
    if (items.any((b) => b?.id == broadcast.id)) return;
    addItemAtStart(broadcast);
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
    if (keywords == null || keywords.trim().isEmpty) return;
    return updateQuery(_query.updateKeywords(keywords.trim()));
  }

  /// Read-only access to the current query (useful for debugging / tests).
  BroadcastQuery get currentQuery => _query;

  @override
  void onDispose() {
    _endedBroadcastSub?.cancel();
    _endedBroadcastSub = null;

    _newBroadcastSub?.cancel();
    _newBroadcastSub = null;

    super.onDispose();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/shared.dart';

class DiscoverNowLiveManager with MLogger implements Disposable {
  DiscoverNowLiveManager(this._source);

  final IBroadcastFeedSource _source;

  final broadcasts = ValueNotifier<PagedList<Broadcast?>>(
    const PagedList.empty(),
  );

  final keywords = ValueNotifier<String?>(null);

  final error = ValueNotifier<MenoException?>(null);

  StreamSubscription<Broadcast>? _startedSubscription;
  StreamSubscription<EndedBroadcast>? _endedSubscription;

  // ==========================================================================
  // COMMANDS
  // ==========================================================================

  /// Fetches the first page. Called on initial build.
  /// Pipes into the socket subscription so both start together.
  late final initialize = Command.createAsyncNoParamNoResult(
    _initializeImpl,
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(listenToSocket);

  /// Subscribes to WebSocket events for real-time updates.
  /// New broadcasts are prepended; ended broadcasts are removed.
  late final listenToSocket = Command.createAsyncNoParamNoResult(
    _listenToSocketImpl,
    errorFilterFn: menoExceptionFilter,
  );

  /// Loads the next page and merges it into [broadcasts].
  late final fetchMore = Command.createAsyncNoParamNoResult(
    _fetchMoreImpl,
    errorFilterFn: menoExceptionFilter,
  );

  /// Updates [keywords] and resets to page 1 with the new keyword filter.
  /// Cancels and restarts the socket subscription so real-time updates
  /// respect the active keyword filter.
  late final search = Command.createAsyncNoResult<String?>(
    _searchImpl,
    errorFilterFn: menoExceptionFilter,
  );

  /// Resets keywords and refreshes from page 1.
  late final refresh = Command.createAsyncNoParamNoResult(
    _refreshImpl,
    errorFilterFn: menoExceptionFilter,
  );

  late final isLoading = initialize.isRunning.combineLatest(
    refresh.isRunning,
    (isInitializing, isRefreshing) => isInitializing || isRefreshing,
  );

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  bool get _canFetchMore =>
      broadcasts.value.currentPage < broadcasts.value.totalPages;

  BroadcastQuery get _currentQuery => BroadcastQuery.nowLive().copyWith(
    keywords: keywords.value,
    pagination: PaginationParams(page: broadcasts.value.currentPage),
  );

  // ==========================================================================
  // IMPLEMENTATIONS
  // ==========================================================================

  Future<void> _initializeImpl() async {
    error.value = null;
    final query = BroadcastQuery.nowLive().copyWith(keywords: keywords.value);
    final result = await _source.getBroadcasts(query);
    result.fold((failure) {
      error.value = failure;
      throw failure;
    }, (page) => broadcasts.value = page);
  }

  Future<void> _listenToSocketImpl() async {
    // Cancel existing socket subscriptions before re-subscribing
    await _startedSubscription?.cancel();
    await _endedSubscription?.cancel();

    _startedSubscription = _source.onBroadcastStarted.listen((incoming) {
      final current = List<Broadcast?>.from(broadcasts.value.items);
      final exists = current.any((b) => b?.id == incoming.id);
      if (!exists) {
        broadcasts.value = broadcasts.value.copyWith(
          items: [incoming, ...current],
        );
      }
    });

    _endedSubscription = _source.onBroadcastEnded.listen((ended) {
      final current = List<Broadcast?>.from(broadcasts.value.items);
      current.removeWhere((b) => b?.id != ended.details.id);
      broadcasts.value = broadcasts.value.copyWith(items: current);
    });
  }

  Future<void> _fetchMoreImpl() async {
    if (!_canFetchMore) return;

    final nextQuery = _currentQuery.nextPage();
    final result = await _source.getBroadcasts(nextQuery);
    result.fold(
      (failure) => throw failure,
      (page) => broadcasts.value = broadcasts.value.merge(page),
    );
  }

  Future<void> _searchImpl(String? keyword) async {
    keywords.value = keyword?.trim().isEmpty ?? true ? null : keyword?.trim();
    broadcasts.value = const PagedList.empty();

    // Restart: fetch page 1 with new keyword, then re-subscribe socket
    await _initializeImpl();
    await _listenToSocketImpl();
  }

  Future<void> _refreshImpl() async {
    keywords.value = null;
    broadcasts.value = const PagedList.empty();
    await _initializeImpl();
    await _listenToSocketImpl();
  }

  @override
  FutureOr<dynamic> onDispose() async {
    await _startedSubscription?.cancel();
    await _endedSubscription?.cancel();

    _startedSubscription = null;
    _endedSubscription = null;

    broadcasts.dispose();
    keywords.dispose();
    error.dispose();

    initialize.dispose();
    listenToSocket.dispose();
    fetchMore.dispose();
    search.dispose();
    refresh.dispose();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';
import 'package:meno/shared/domain/i_broadcast_feed_source.dart';

class DiscoverRecentlyLiveManager with MLogger implements Disposable {
  DiscoverRecentlyLiveManager(this._source);

  final IBroadcastFeedSource _source;

  final broadcasts = ValueNotifier<PagedList<Broadcast?>>(
    const PagedList.empty(),
  );

  final error = ValueNotifier<MenoException?>(null);

  StreamSubscription<EndedBroadcast>? _endedBroadcastSubscription;

  late final initialize = Command.createAsyncNoParamNoResult(
    _initializeImpl,
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(listenToSocket);

  late final listenToSocket = Command.createAsyncNoParamNoResult(
    _listenToSocketImpl,
    errorFilterFn: menoExceptionFilter,
  );

  late final fetchMore = Command.createAsyncNoParamNoResult(
    _fetchMoreImpl,
    errorFilterFn: menoExceptionFilter,
  );

  late final refresh = Command.createAsyncNoParamNoResult(
    _refreshImpl,
    errorFilterFn: menoExceptionFilter,
  );

  late final isLoading = initialize.isRunning.combineLatest(
    refresh.isRunning,
    (isInitializing, isRefreshing) => isInitializing || isRefreshing,
  );

  Future<void> _initializeImpl() async {
    error.value = null;
    final result = await _source.getBroadcasts(BroadcastQuery.recentlyLive());
    result.fold((failure) {
      error.value = failure;
      throw failure;
    }, (page) => broadcasts.value = page);
  }

  Future<void> _listenToSocketImpl() async {
    // Cancel existing socket subscriptions before re-subscribing
    await _endedBroadcastSubscription?.cancel();

    _endedBroadcastSubscription = _source.onBroadcastEnded.listen((ended) {
      final current = List<Broadcast?>.from(broadcasts.value.items);
      final exists = current.any((b) => b?.id == ended.details.id);
      if (!exists) {
        broadcasts.value = broadcasts.value.copyWith(
          items: [ended.details, ...current],
        );
      }
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

  Future<void> _refreshImpl() async {
    broadcasts.value = const PagedList.empty();
    await _initializeImpl();
    await _listenToSocketImpl();
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  bool get _canFetchMore =>
      broadcasts.value.currentPage < broadcasts.value.totalPages;

  BroadcastQuery get _currentQuery => BroadcastQuery.recentlyLive().copyWith(
    pagination: PaginationParams(page: broadcasts.value.currentPage),
  );

  @override
  FutureOr<dynamic> onDispose() async {
    await _endedBroadcastSubscription?.cancel();

    _endedBroadcastSubscription = null;

    broadcasts.dispose();
    error.dispose();

    initialize.dispose();
    listenToSocket.dispose();
    fetchMore.dispose();
    refresh.dispose();
  }
}

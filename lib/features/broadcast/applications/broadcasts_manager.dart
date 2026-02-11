import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

/// Manages broadcast list state and operations
class BroadcastsManager with Disposable {
  BroadcastsManager({
    required IBroadcastRepository repository,
    required BroadcastQuery query,
  }) : _repository = repository,
       _query = query;

  final IBroadcastRepository _repository;
  BroadcastQuery _query;

  // ========================================================================
  // STATE
  // ========================================================================

  /// Current list of broadcasts with pagination metadata
  final broadcasts = ValueNotifier<PagedList<Broadcast?>>(
    const PagedList.empty(),
  );

  /// Current query being used
  BroadcastQuery get query => _query;

  // ========================================================================
  // COMMANDS
  // ========================================================================
  late final fetch = Command.createAsyncNoResult<BroadcastQuery?>(
    _fetchImpl,
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

  late final search = Command.createAsyncNoResult<String?>(
    _searchImpl,
    errorFilterFn: menoExceptionFilter,
  );

  // ========================================================================
  // COMMAND IMPLEMENTATIONS
  // ========================================================================
  Future<void> _fetchImpl(BroadcastQuery? query) async {
    final queryToUse = query ?? _query;
    final result = await _repository.getBroadcasts(queryToUse);

    result.fold((error) => throw error, (newPage) {
      _query = queryToUse;

      // If first page, replace; otherwise merge
      if (queryToUse.pagination.isFirstPage) {
        broadcasts.value = newPage;
      } else {
        broadcasts.value = broadcasts.value.merge(newPage);
      }
    });
  }

  Future<void> _fetchMoreImpl() async {
    // Don't load if already loading or no more data
    if (fetch.isRunning.value || !canFetchMore) return;

    final nextQuery = _query.nextPage();
    await _fetchImpl(nextQuery);
  }

  Future<void> _refreshImpl() async {
    // Reset to first page and reload
    final resetQuery = _query.resetPage();
    broadcasts.value = const PagedList.empty(); // Clear current data
    await _fetchImpl(resetQuery);
  }

  Future<void> _searchImpl(String? keywords) async {
    // Update query with new keywords and reset to first page
    final searchQuery = _query.updateKeywords(keywords);
    broadcasts.value = const PagedList.empty(); // Clear current data
    await _fetchImpl(searchQuery);
  }

  // ========================================================================
  // COMPUTED PROPERTIES
  // ========================================================================

  /// Whether more data can be loaded
  bool get canFetchMore => broadcasts.value.hasMore && !fetch.isRunning.value;

  /// Whether currently loading
  bool get isLoading => fetch.isRunning.value;

  /// Whether list is empty
  bool get isEmpty => broadcasts.value.items.isEmpty;

  /// Whether currently on first page
  bool get isFirstPage => broadcasts.value.currentPage == 1;

  // ========================================================================
  // DISPOSAL
  // ========================================================================

  @override
  FutureOr<dynamic> onDispose() {
    broadcasts.dispose();
    fetch.dispose();
  }
}

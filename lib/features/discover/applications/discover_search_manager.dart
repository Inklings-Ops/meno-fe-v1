import 'dart:async';

import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/discover/domain/domain.dart';
import 'package:meno/features/discover/infrastructure/infrastructure.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/shared/domain/broadcast_query.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class DiscoverSearchManager with MLogger implements Disposable {
  DiscoverSearchManager({
    required IBroadcastRepository broadcastRepository,
    required IProfileRepository profileRepository,
    required DiscoverLocalDataSource local,
    required Id userId,
  }) : _broadcastRepository = broadcastRepository,
       _profileRepository = profileRepository,
       _local = local,
       _userId = userId;

  final IBroadcastRepository _broadcastRepository;
  final IProfileRepository _profileRepository;
  final DiscoverLocalDataSource _local;
  final Id _userId;

  // State
  final query = ValueNotifier<String>('');
  final results = ValueNotifier<List<DiscoverSearchResult>>([]);
  final isLoading = ValueNotifier(false);
  final isFetchingMore = ValueNotifier(false);
  final hasMore = ValueNotifier(false);

  static const int _pageSize = 6; // Per type, per page

  int _broadcastPage = 1;
  int _profilePage = 1;

  bool _broadcastHasMore = true;
  bool _profileHasMore = true;

  CancelToken? _cancelToken;

  StreamSubscription<List<String>>? _recentSearchesSub;

  /// Reactive list of recent searches — the view listens to this directly.
  late final recentSearches = ValueNotifier<List<String>>([]);

  late final initialize = Command.createSyncNoParamNoResult(() {
    _recentSearchesSub?.cancel();
    _recentSearchesSub = null;

    final id = _userId.getOrCrash();

    _recentSearchesSub = _local.watchRecentSearches(id).listen((terms) {
      recentSearches.value = terms;
    });

    recentSearches.value = _local.getRecentSearches(id);
  });

  late final search = Command.createAsyncNoResult<String>((keywords) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    _resetPagination();
    query.value = keywords;

    if (keywords.trim().isEmpty) {
      results.value = [];
      return;
    }

    isLoading.value = true;

    final (broadcasts, profiles) = await (
      _fetchBroadcasts(keywords, 1),
      _fetchProfiles(keywords, 1),
    ).wait;

    results.value = _merge(broadcasts, profiles);
    isLoading.value = false;

    // Persist only after a successful search that produced results
    if (results.value.isNotEmpty) {
      await _local.addRecentSearch(_userId.getOrCrash(), keywords.trim());
    }
  }, errorFilterFn: menoExceptionFilter);

  late final fetchMore = Command.createAsyncNoParamNoResult(() async {
    if (!hasMore.value || isFetchingMore.value) return;
    isFetchingMore.value = true;

    final keyword = query.value;

    final (broadcasts, profiles) = await (
      _broadcastHasMore
          ? _fetchBroadcasts(keyword, _broadcastPage)
          : Future.value(<Broadcast?>[]),
      _profileHasMore
          ? _fetchProfiles(keyword, _profilePage)
          : Future.value(<Profile?>[]),
    ).wait;

    results.value = [...results.value, ..._merge(broadcasts, profiles)];
    isFetchingMore.value = false;
  }, errorFilterFn: menoExceptionFilter);

  late final removeRecentSearch = Command.createAsyncNoResult<String>((
    term,
  ) async {
    await _local.removeRecentSearch(_userId.getOrCrash(), term);
    recentSearches.value = _local.getRecentSearches(_userId.getOrCrash());
  }, errorFilterFn: menoExceptionFilter);

  late final clearRecentSearches = Command.createAsyncNoParamNoResult(() async {
    await _local.clearRecentSearches(_userId.getOrCrash());
    recentSearches.value = [];
  }, errorFilterFn: menoExceptionFilter);

  Future<List<Broadcast?>> _fetchBroadcasts(String keywords, int page) async {
    if (!_broadcastHasMore) return [];

    final result = await _broadcastRepository.getBroadcasts(
      BroadcastQuery.search(
        keywords: keywords,
        pagination: PaginationParams(page: page, size: _pageSize),
      ),
      cancelToken: _cancelToken,
    );

    return result.fold(
      (failure) {
        if (failure is CancelledException) return [];
        log.e('DiscoverSearchManager: fetch failed — $failure');
        return [];
      },
      (paged) {
        _broadcastPage = paged.currentPage + 1;
        _broadcastHasMore = paged.hasMore;
        _updateHasMore();
        return paged.items;
      },
    );
  }

  Future<List<Profile?>> _fetchProfiles(String keywords, int page) async {
    if (!_profileHasMore) return [];

    final result = await _profileRepository.getProfiles(
      keywords: keywords,
      pagination: PaginationParams(page: page),
      cancelToken: _cancelToken,
    );

    return result.fold(
      (failure) {
        if (failure is CancelledException) return [];
        log.e('DiscoverSearchManager: fetch failed — $failure');
        return [];
      },
      (paged) {
        _profilePage = paged.currentPage + 1;
        _profileHasMore = paged.hasMore;
        _updateHasMore();
        return paged.items;
      },
    );
  }

  void _resetPagination() {
    _broadcastPage = 1;
    _profilePage = 1;
    _broadcastHasMore = true;
    _profileHasMore = true;
    hasMore.value = false;
  }

  void _updateHasMore() => hasMore.value = _broadcastHasMore || _profileHasMore;

  List<DiscoverSearchResult> _merge(
    List<Broadcast?> broadcasts,
    List<Profile?> profiles,
  ) {
    final result = <DiscoverSearchResult>[];
    final b = broadcasts.whereType<Broadcast>().toList();
    final p = profiles.whereType<Profile>().toList();

    var bi = 0;
    var pi = 0;

    while (bi < b.length || pi < p.length) {
      for (var i = 0; i < 3 && bi < b.length; i++, bi++) {
        result.add(BroadcastResult(b[bi]));
      }

      if (pi < p.length) result.add(ProfileResult(p[pi++]));
    }

    return result;
  }

  @override
  FutureOr<dynamic> onDispose() async {
    await _recentSearchesSub?.cancel();
    _recentSearchesSub = null;

    query.dispose();
    results.dispose();
    isLoading.dispose();
    isFetchingMore.dispose();
    hasMore.dispose();

    initialize.dispose();
    search.dispose();
    fetchMore.dispose();
    removeRecentSearch.dispose();
    clearRecentSearches.dispose();
  }
}

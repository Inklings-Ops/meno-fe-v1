import 'dart:async';

import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/model/broadcast_query.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/discover/model/_model.dart';
import 'package:meno/features/discover/services/_services.dart';
import 'package:meno/features/profile/profile.dart';

class DiscoverSearchManager with MLogger implements Disposable {
  DiscoverSearchManager({
    required BroadcastHttpService broadcastHttp,
    required ProfileHttpService profileHttp,
    required DiscoverLocalService local,
    required Id userId,
  }) : _broadcastHttp = broadcastHttp,
       _profileHttp = profileHttp,
       _local = local,
       _userId = userId;

  final BroadcastHttpService _broadcastHttp;
  final ProfileHttpService _profileHttp;
  final DiscoverLocalService _local;
  final Id _userId;

  // State
  final query = ValueNotifier<String>('');
  final results = ValueNotifier<List<DiscoverSearchResult>>([]);
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

    final (broadcasts, profiles) = await (
      _fetchBroadcasts(keywords, 1),
      _fetchProfiles(keywords, 1),
    ).wait;

    results.value = _merge(broadcasts, profiles);

    // Persist only after a successful search that produced results
    if (results.value.isNotEmpty) {
      await _local.addRecentSearch(_userId.getOrCrash(), keywords.trim());
    }
  }, errorFilterFn: menoExceptionFilter);

  late final fetchMore = Command.createAsyncNoParamNoResult(
    () async {
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
    },
    errorFilterFn: menoExceptionFilter,
    restriction: hasMore.map((value) => !value),
  );

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

    try {
      final result = await _broadcastHttp.getBroadcasts(
        BroadcastQuery.search(
          keywords: keywords,
          pagination: PaginationParams(page: page, size: _pageSize),
        ),
        cancelToken: _cancelToken,
      );

      _broadcastPage = result.currentPage + 1;
      _broadcastHasMore = result.hasMore;
      _updateHasMore();

      return result.items;
    } catch (error) {
      if (error is CancelledException) return [];
      log.e('DiscoverSearchManager: broadcasts fetch failed — $error');
      return [];
    }
  }

  Future<List<Profile?>> _fetchProfiles(String keywords, int page) async {
    if (!_profileHasMore) return [];

    try {
      final result = await _profileHttp.getProfiles(
        keywords: keywords,
        pagination: PaginationParams(page: page),
        cancelToken: _cancelToken,
      );

      _profilePage = result.currentPage + 1;
      _profileHasMore = result.hasMore;
      _updateHasMore();

      return result.items;
    } catch (error) {
      if (error is CancelledException) return [];
      log.e('DiscoverSearchManager: profiles fetch failed — $error');
      return [];
    }
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
    hasMore.dispose();

    initialize.dispose();
    search.dispose();
    fetchMore.dispose();
    removeRecentSearch.dispose();
    clearRecentSearches.dispose();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';
import 'package:meno/shared/domain/i_broadcast_feed_source.dart';

/// Application-layer manager for the "My Profile" screen.
///
/// Responsibilities:
/// - Hydrate the current user's profile from cache + network on mount.
/// - Drive paginated broadcast tabs (recent, all) via [IBroadcastFeedSource].
/// - Expose per-tab state through lightweight [ValueNotifier]s so individual
///   tab widgets can rebuild independently — no whole-page rebuilds.
///
/// Lifecycle: registered in the user scope (singleton per session).
/// The profile page calls [initialize] once on first mount.
class MyProfileManager with MLogger implements Disposable, WillSignalReady {
  MyProfileManager({
    required IProfileRepository profileRepository,
    required IBroadcastFeedSource broadcastFeed,
    required Id userId,
  }) : _profileRepository = profileRepository,
       _broadcastFeed = broadcastFeed,
       _userId = userId;

  final IProfileRepository _profileRepository;
  final IBroadcastFeedSource _broadcastFeed;
  final Id _userId;

  // =========================================================================
  // PUBLIC STATE — widgets watch these
  // =========================================================================

  /// Delegates directly to the repository notifier — zero duplication.
  ValueListenable<Profile?> get profile => _profileRepository.myProfile;

  // ---- Recent Broadcasts tab -----------------------------------------------

  final recentBroadcasts = ListNotifier<Broadcast?>(data: []);
  final recentIsLoading = ValueNotifier(false);
  final recentHasMore = ValueNotifier(false);
  final recentError = ValueNotifier<String?>(null);

  int _recentPage = 1;
  static const int _pageSize = 10;

  final allBroadcasts = ListNotifier<Broadcast?>(data: []);
  final allIsLoading = ValueNotifier(false);
  final allHasMore = ValueNotifier(false);
  final allError = ValueNotifier<String?>(null);

  int _allPage = 1;

  // =========================================================================
  // COMMANDS
  // =========================================================================

  /// Fetches the user's profile. Called once on screen mount.
  late final initialize = Command.createAsyncNoParamNoResult(
    _refreshProfile,
    errorFilterFn: menoExceptionFilter,
  );

  /// Pull-to-refresh — re-fetches everything.
  late final refresh = Command.createAsyncNoParamNoResult(() async {
    await Future.wait([
      _refreshProfile(),
      _fetchRecentBroadcasts(reset: true),
      _fetchAllBroadcasts(reset: true),
    ]);
  }, errorFilterFn: menoExceptionFilter);

  /// Loads the next page of recent broadcasts (called by scroll listener).
  late final fetchMoreRecent = Command.createAsyncNoParamNoResult(
    () => _fetchRecentBroadcasts(reset: false),
    errorFilterFn: menoExceptionFilter,
  );

  /// Loads the next page of all broadcasts (called by scroll listener).
  late final fetchMoreAll = Command.createAsyncNoParamNoResult(
    () => _fetchAllBroadcasts(reset: false),
    errorFilterFn: menoExceptionFilter,
  );

  // =========================================================================
  // PRIVATE IMPLEMENTATION
  // =========================================================================

  Future<void> _refreshProfile() async {
    final result = await _profileRepository.fetchMyProfile(_userId);
    result.fold((err) => log.w('Profile fetch error: ${err.message}'), (_) {
      GetIt.instance.signalReady(this);
    });
  }

  Future<void> _fetchRecentBroadcasts({required bool reset}) async {
    if (!reset && !recentHasMore.value) return;
    if (recentIsLoading.value) return;

    if (reset) {
      _recentPage = 1;
      recentError.value = null;
    }

    recentIsLoading.value = true;

    try {
      final query = BroadcastQuery.byCreator(
        creatorId: _userId,
        sortParams: SortParams.endTimeDesc,
        pagination: PaginationParams(page: _recentPage, size: _pageSize),
      ).copyWith(endTimeRange: const TimeRange.exists());

      final result = await _broadcastFeed.getBroadcasts(query);

      result.fold((err) => recentError.value = err.message, (page) {
        if (reset) {
          recentBroadcasts
            ..startTransAction()
            ..clear()
            ..addAll(page.items)
            ..endTransAction();
        } else {
          recentBroadcasts
            ..startTransAction()
            ..addAll(page.items)
            ..endTransAction();
        }
        recentHasMore.value = page.hasMore;
        _recentPage = page.currentPage + 1;
      });
    } finally {
      recentIsLoading.value = false;
    }
  }

  Future<void> _fetchAllBroadcasts({required bool reset}) async {
    if (!reset && !allHasMore.value) return;
    if (allIsLoading.value) return;

    if (reset) {
      _allPage = 1;
      allError.value = null;
    }

    allIsLoading.value = true;

    try {
      final query = BroadcastQuery.byCreator(
        creatorId: _userId,
        sortParams: SortParams.startTimeDesc,
        pagination: PaginationParams(page: _allPage, size: _pageSize),
      );

      final result = await _broadcastFeed.getBroadcasts(query);

      result.fold((err) => allError.value = err.message, (page) {
        if (reset) {
          allBroadcasts
            ..startTransAction()
            ..clear()
            ..addAll(page.items)
            ..endTransAction();
        } else {
          allBroadcasts
            ..startTransAction()
            ..addAll(page.items)
            ..endTransAction();
        }
        allHasMore.value = page.hasMore;
        _allPage = page.currentPage + 1;
      });
    } finally {
      allIsLoading.value = false;
    }
  }

  // =========================================================================
  // DISPOSABLE
  // =========================================================================

  @override
  FutureOr<dynamic> onDispose() {
    recentBroadcasts.dispose();
    recentIsLoading.dispose();
    recentHasMore.dispose();
    recentError.dispose();

    allBroadcasts.dispose();
    allIsLoading.dispose();
    allHasMore.dispose();
    allError.dispose();

    initialize.dispose();
    refresh.dispose();
    fetchMoreRecent.dispose();
    fetchMoreAll.dispose();
  }
}

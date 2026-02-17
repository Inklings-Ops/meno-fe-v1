import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

final class ParticipantsManager with MLogger implements Disposable {
  ParticipantsManager({
    required BroadcastSession session,
    required IBroadcastRepository repository,
  }) : _session = session,
       _repository = repository;

  final BroadcastSession _session;
  final IBroadcastRepository _repository;

  Id get _broadcastId => _session.broadcast.id;

  // =========================================================================
  // STORAGE
  // =========================================================================
  /// Current live participants (can leave and rejoin)
  final _participantsMap = MapNotifier<String, Participant>(data: {});

  /// ALL participants that EVER joined (historical - never removed)
  final _allTimeParticipantsMap = <String, Participant>{};

  /// Sorted list of current live participants
  final _sortedParticipants = ListNotifier<Participant>(data: []);

  /// Last 3 participants to join (for avatar stack)
  final recentParticipants = ValueNotifier<List<Participant>>([]);

  // =========================================================================
  // UI STATE
  // =========================================================================
  final searchQuery = ValueNotifier<String?>(null);

  final isLoading = ValueNotifier<bool>(true);

  final displayedCount = ValueNotifier<int>(50); // Virtual pagination

  final isSearching = ValueNotifier<bool>(false);

  // =========================================================================
  // CONSTANTS
  // =========================================================================
  static const int _initialDisplayCount = 50;
  static const int _pageSize = 50;
  static const int _maxWithoutViewAll = 200;
  static const int _searchDebounceMs = 300;

  // =========================================================================
  // SUBSCRIPTIONS
  // =========================================================================
  StreamSubscription<List<Participant>>? _participantsSubscription;
  bool _isInitialized = false;

  // =========================================================================
  // COMPUTED VALUES
  // =========================================================================

  /// Total participant count
  late final totalCount = ValueNotifier<int>(_participantsMap.length);

  /// Total number of ALL participants that ever joined (only goes up!)
  late final allTimeCount = ValueNotifier<int>(0);

  /// Host participant (nullable)
  late final host = _sortedParticipants.where((p) => p.isHost).firstOrNull;

  /// All cohosts
  late final cohosts = _sortedParticipants.where((p) => p.isCohost).toList();

  /// All listeners
  late final listeners = _sortedParticipants
      .where((p) => p.isListener)
      .toList();

  /// Filtered + paginated participants for display
  ///
  /// Pipeline:
  /// 1. Start with sorted list
  /// 2. Filter by search query (if active)
  /// 3. Apply pagination limit
  /// 4. Debounce for performance
  late final displayedParticipants = searchQuery
      .combineLatest3(_sortedParticipants, displayedCount, (
        query,
        participants,
        count,
      ) {
        // Filter by search
        final isQueryEmpty = query == null || query.isEmpty;
        final filtered = isQueryEmpty
            ? participants
            : participants.where((p) {
                final name = p.fullName.getOrElse((_) => '').toLowerCase();
                final q = query.toLowerCase();
                return name.contains(q);
              }).toList();

        // Apply pagination
        final end = count.clamp(0, filtered.length);
        return filtered.sublist(0, end);
      })
      .debounce(const Duration(milliseconds: _searchDebounceMs));

  /// Whether more participants can be loaded
  late final hasMore = displayedCount.combineLatest(
    totalCount,
    (displayed, total) => displayed < total && displayed < _maxWithoutViewAll,
  );

  /// Whether showing all available participants
  late final isShowingAll = displayedCount.combineLatest(
    totalCount,
    (displayed, total) => displayed >= total,
  );

  // =========================================================================
  // COMMANDS
  // =========================================================================
  late final initialize = Command.createAsyncNoParamNoResult(() async {
    if (_isInitialized) {
      log.w('ParticipantsManager: Already initialized');
      return;
    }

    log.i('ParticipantsManager: Waiting for LiveSessionManager...');
    await di.isReady<LiveSessionManager>();

    log.i('ParticipantsManager: Initializing for broadcast $_broadcastId');
    isLoading.value = true;

    _participantsSubscription = _repository
        .watchLiveParticipants(_broadcastId)
        .listen(_handleEvent, onError: _handleError);

    // Setup search query listener
    searchQuery
        .debounce(const Duration(milliseconds: _searchDebounceMs))
        .listen(_handleSearchChange);

    _isInitialized = true;
  });

  /// Load more participants (pagination)
  late final loadMore = Command.createSyncNoParamNoResult(() {
    final current = displayedCount.value;
    final total = totalCount.value;

    if (current >= total) {
      log.d('ParticipantsManager: Already showing all');
      return;
    }

    final newCount = (current + _pageSize).clamp(0, _maxWithoutViewAll);
    displayedCount.value = newCount;
    log.d('ParticipantsManager: Displaying $newCount/$total');
  });

  /// Show all participants (up to max)
  late final showAll = Command.createSyncNoParamNoResult(() {
    final total = totalCount.value;
    displayedCount.value = total.clamp(0, _maxWithoutViewAll);
  });

  /// Reset pagination to initial state
  late final resetPagination = Command.createSyncNoParamNoResult(() {
    displayedCount.value = _initialDisplayCount;
  });

  /// Update search query
  late final updateSearch = Command.createSyncNoResult((String query) {
    searchQuery.value = query.trim();
  });

  /// Clear search
  late final clearSearch = Command.createSyncNoParamNoResult(() {
    searchQuery.value = '';
    isSearching.value = false;
  });

  // =========================================================================
  // PRIVATE METHODS
  // =========================================================================

  /// Update participants with new list
  void _handleEvent(List<Participant> participants) {
    log.d('ParticipantsManager: Received ${participants.length} participants');

    // Update current live participants
    _participantsMap.startTransAction();
    _participantsMap.clear();

    for (final participant in participants) {
      final id = participant.id.getOrCrash();
      _participantsMap[id] = participant;

      // ⭐ Add to all-time map (never removed!)
      if (!_allTimeParticipantsMap.containsKey(id)) {
        _allTimeParticipantsMap[id] = participant;
      }
    }

    _participantsMap.endTransAction();

    // Update all-time count
    allTimeCount.value = _allTimeParticipantsMap.length;

    // Update recent participants (last 3)
    _updateRecentParticipants();

    // Rebuild sorted list
    _rebuildSortedList();

    isLoading.value = false;
  }

  /// Rebuild sorted list from map
  void _rebuildSortedList() {
    log.d('ParticipantsManager: Rebuilding sorted list');
    final participants = _participantsMap.value.values.toList();
    totalCount.value = participants.length;

    // Sort by role priority only
    participants.sort((a, b) {
      final priorityA = _getRolePriority(a.role);
      final priorityB = _getRolePriority(b.role);
      return priorityA.compareTo(priorityB);
    });

    // Clear before adding to avoid duplicates
    _sortedParticipants.startTransAction();
    _sortedParticipants.clear();
    _sortedParticipants.addAll(participants);
    _sortedParticipants.endTransAction();
  }

  /// Update the last 3 participants for avatar stack
  void _updateRecentParticipants() {
    final all = _allTimeParticipantsMap.values.toList();

    // Take last 3 (most recent joiners)
    final recent = all.length > 3 ? all.sublist(all.length - 3) : all;

    recentParticipants.value = recent;
  }

  /// Get numeric priority for role (lower = higher priority)
  int _getRolePriority(ParticipantRole role) => switch (role) {
    .host => 0,
    .cohost => 1,
    .listener => 2,
    _ => 999, // Unknown participant role should appear last,
  };

  /// Handle search query changes
  void _handleSearchChange(String? query, ListenableSubscription _) {
    final isQueryEmpty = query == null || query.isEmpty;
    isSearching.value = !isQueryEmpty;

    // Show more results when searching
    if (!isQueryEmpty && displayedCount.value < _maxWithoutViewAll) {
      displayedCount.value = _maxWithoutViewAll;
    }
  }

  /// Handle stream errors
  void _handleError(dynamic error) {
    log.e('ParticipantsManager: Stream error - $error');
    isLoading.value = false;
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('ParticipantsManager: Disposing');
    log.i(
      '''ParticipantsManager: Final stats - Live: ${totalCount.value}, All-time: ${allTimeCount.value}''',
    );

    await _participantsSubscription?.cancel();

    _participantsMap.dispose();
    _sortedParticipants.dispose();
    searchQuery.dispose();
    isSearching.dispose();
    displayedCount.dispose();
    isLoading.dispose();
    allTimeCount.dispose();
    recentParticipants.dispose();

    initialize.dispose();
    loadMore.dispose();
    showAll.dispose();
    resetPagination.dispose();
    updateSearch.dispose();
    clearSearch.dispose();

    _isInitialized = false;
  }
}

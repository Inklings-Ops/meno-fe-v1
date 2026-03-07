import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/broadcast/model/model.dart';
import 'package:meno/features/broadcast/services/_services.dart';

final class ParticipantsManager with MLogger implements Disposable {
  ParticipantsManager({
    required BroadcastHttpService http,
    required BroadcastSocketService socket,
    required BroadcastSession session,
  }) : _http = http,
       _socket = socket,
       _session = session;

  final BroadcastHttpService _http;
  final BroadcastSocketService _socket;
  final BroadcastSession _session;

  Id get _broadcastId => _session.broadcast.id;

  static const int _initialDisplayCount = 50;
  static const int _pageSize = 50;
  static const int _maxWithoutViewAll = 200;
  static const int _searchDebounceMs = 300;

  StreamSubscription<Participant>? _onParticipantJoined;
  StreamSubscription<Participant>? _onParticipantLeft;

  bool _isInitialized = false;

  /// Current live participants (can leave and rejoin)
  final _participantsMap = MapNotifier<String, Participant>(data: {});

  /// ALL participants that EVER joined (historical - never removed)
  final _allTimeParticipantsMap = <String, Participant>{};

  /// Sorted list of current live participants
  final _sortedParticipants = ListNotifier<Participant>(data: []);

  /// Last 3 participants to join (for avatar stack)
  final recentParticipants = ValueNotifier<List<Participant>>([]);

  final searchQuery = ValueNotifier<String?>(null);
  final displayedCount = ValueNotifier<int>(50);
  final isSearching = ValueNotifier<bool>(false);

  late final initialize = Command.createSyncNoParamNoResult(() {
    if (_isInitialized) return;

    _onParticipantJoined = _socket.onParticipantJoined.listen((participant) {
      _participantsMap[participant.id.getOrCrash()] = participant;
    });

    _onParticipantLeft = _socket.onParticipantLeft.listen((participant) {
      _participantsMap.remove(participant.id.getOrCrash());
    });

    const debounceDuration = Duration(milliseconds: _searchDebounceMs);
    searchQuery.debounce(debounceDuration).listen(_handleSearchChange);

    _isInitialized = true;
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(_fetchParticipants);

  // Initial fetch command after the socket event have been subscribed to
  late final _fetchParticipants = Command.createAsyncNoParamNoResult(() async {
    final participants = await _http.getLiveListeners(_broadcastId);
    _handleParticipantsList(participants);
  }, errorFilterFn: menoExceptionFilter);

  /// Load more participants (pagination)
  late final loadMore = Command.createSyncNoParamNoResult(() {
    final current = displayedCount.value;
    final total = totalCount.value;

    // Already showing all the participants
    if (current >= total) return;

    final newCount = (current + _pageSize).clamp(0, _maxWithoutViewAll);
    displayedCount.value = newCount;
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

  late final isLoading = initialize.isRunning.combineLatest(
    _fetchParticipants.isRunning,
    (initializing, fetching) => initializing || fetching,
  );

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

  void _handleParticipantsList(List<Participant>? participants) {
    if (participants == null || participants.isEmpty) return;

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
  }

  /// Rebuild sorted list from map
  void _rebuildSortedList() {
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
    ParticipantRole.host => 0,
    ParticipantRole.cohost => 1,
    ParticipantRole.listener => 2,
    _ => 999, // Unknown participant role should appear last,
  };

  void _handleSearchChange(String? query, ListenableSubscription _) {
    final isQueryEmpty = query == null || query.isEmpty;
    isSearching.value = !isQueryEmpty;

    // Show more results when searching
    if (!isQueryEmpty && displayedCount.value < _maxWithoutViewAll) {
      displayedCount.value = _maxWithoutViewAll;
    }
  }

  String _getErrorMessage(Object? error) {
    if (error is MenoException) return error.message;
    return error.toString();
  }

  @override
  FutureOr<dynamic> onDispose() async {
    await _onParticipantJoined?.cancel();
    await _onParticipantLeft?.cancel();

    _onParticipantJoined = null;
    _onParticipantLeft = null;

    _participantsMap.dispose();
    _sortedParticipants.dispose();
    searchQuery.dispose();
    isSearching.dispose();
    displayedCount.dispose();
    allTimeCount.dispose();
    recentParticipants.dispose();

    _fetchParticipants.dispose();
    initialize.dispose();
    loadMore.dispose();
    showAll.dispose();
    resetPagination.dispose();
    updateSearch.dispose();
    clearSearch.dispose();

    _isInitialized = false;
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/broadcast/model/_model.dart';
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

  /// Map for O(1) lookup of current participants.
  final _participantsMap = <String, Participant>{};

  /// Set of unique IDs that joined throughout the broadcast lifespan.
  final Set<String> _allTimeIds = {};

  /// Current live participants (sorted: Host -> Cohosts -> Listeners).
  final _sortedParticipants = ListNotifier<Participant>(data: []);

  /// Unique count of participants who joined (only goes up).
  final allTimeCount = ValueNotifier<int>(0);

  /// Last 3 unique participants who joined (for avatar stack).
  final recentParticipants = ListNotifier<Participant>(data: []);

  final searchQuery = ValueNotifier<String?>(null);
  final displayedCount = ValueNotifier<int>(50);
  final isSearching = ValueNotifier<bool>(false);

  late final initialize = Command.createSyncNoParamNoResult(() {
    if (_isInitialized) return;

    _onParticipantJoined = _socket.onParticipantJoined.listen(_handleJoin);
    _onParticipantLeft = _socket.onParticipantLeft.listen(_handleLeave);

    const debounceDuration = Duration(milliseconds: _searchDebounceMs);
    searchQuery.debounce(debounceDuration).listen(_handleSearchChange);

    _isInitialized = true;
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(_fetchParticipants);

  // Initial fetch command after the socket event have been subscribed to
  late final _fetchParticipants = Command.createAsyncNoParamNoResult(() async {
    final participants = await _http.getLiveListeners(_broadcastId);
    _handleInitialList(participants);
  }, errorFilterFn: menoExceptionFilter);

  /// Load more participants (pagination)
  late final loadMore = Command.createSyncNoParamNoResult(() {
    final current = displayedCount.value;
    final total = _sortedParticipants.value.length;

    if (current >= total) return;

    final newCount = (current + _pageSize).clamp(0, _maxWithoutViewAll);
    displayedCount.value = newCount;
  });

  /// Show all participants (up to max)
  late final showAll = Command.createSyncNoParamNoResult(() {
    final total = _sortedParticipants.value.length;
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

  late final isLoading = _fetchParticipants.isRunning;

  /// Current number of live participants.
  late final totalCount =
      (_sortedParticipants as ValueListenable<List<Participant>>).map(
        (list) => list.length,
      );

  /// Host participant (nullable)
  late final host = (_sortedParticipants as ValueListenable<List<Participant>>)
      .map((list) => list.where((p) => p.isHost).firstOrNull);

  /// All cohosts
  late final cohosts =
      (_sortedParticipants as ValueListenable<List<Participant>>).map(
        (list) => list.where((p) => p.isCohost).toList(),
      );

  /// All listeners
  late final listeners =
      (_sortedParticipants as ValueListenable<List<Participant>>).map(
        (list) => list.where((p) => p.isListener).toList(),
      );

  /// Filtered + paginated participants for display
  late final displayedParticipants = searchQuery
      .combineLatest3<List<Participant>, int, List<Participant>>(
        _sortedParticipants,
        displayedCount,
        (query, participants, count) {
          final isQueryEmpty = query == null || query.isEmpty;
          final filtered = isQueryEmpty
              ? participants
              : participants.where((p) {
                  final name = p.fullName.getOrElse((_) => '').toLowerCase();
                  final q = query.toLowerCase();
                  return name.contains(q);
                }).toList();

          final end = count.clamp(0, filtered.length);
          return filtered.sublist(0, end);
        },
      )
      .debounce(const Duration(milliseconds: _searchDebounceMs));

  /// Whether more participants can be loaded
  late final hasMore = displayedCount.combineLatest<int, bool>(
    totalCount,
    (displayed, total) => displayed < total && displayed < _maxWithoutViewAll,
  );

  /// Whether showing all available participants
  late final isShowingAll = displayedCount.combineLatest<int, bool>(
    totalCount,
    (displayed, total) => displayed >= total,
  );

  void _handleJoin(Participant p) {
    final id = p.id.getOrCrash();
    if (_participantsMap.containsKey(id)) return;

    _participantsMap[id] = p;
    _insertIntoSortedList(p);

    // Track unique all-time joins
    if (!_allTimeIds.contains(id)) {
      _allTimeIds.add(id);
      allTimeCount.value++;

      // Keep only the 3 most recent unique joiners
      recentParticipants.add(p);
      if (recentParticipants.length > 3) {
        recentParticipants.removeAt(0);
      }
    }
  }

  void _handleLeave(Participant p) {
    final id = p.id.getOrCrash();
    if (!_participantsMap.containsKey(id)) return;

    _participantsMap.remove(id);
    _sortedParticipants.removeWhere((item) => item.id.getOrCrash() == id);
  }

  void _handleInitialList(List<Participant>? participants) {
    if (participants == null) return;

    _sortedParticipants.startTransAction();
    _sortedParticipants.clear();
    _participantsMap.clear();

    for (final p in participants) {
      final id = p.id.getOrCrash();
      _participantsMap[id] = p;
      _insertIntoSortedList(p);

      if (!_allTimeIds.contains(id)) {
        _allTimeIds.add(id);
        allTimeCount.value++;

        recentParticipants.add(p);
        if (recentParticipants.length > 3) {
          recentParticipants.removeAt(0);
        }
      }
    }
    _sortedParticipants.endTransAction();
  }

  /// Inserts a participant into the correct position based on role priority.
  void _insertIntoSortedList(Participant p) {
    final priority = _getRolePriority(p.role);
    var index = 0;
    for (; index < _sortedParticipants.length; index++) {
      if (_getRolePriority(_sortedParticipants[index].role) > priority) {
        break;
      }
    }
    _sortedParticipants.insert(index, p);
  }

  /// Get numeric priority for role (lower = higher priority).
  int _getRolePriority(ParticipantRole role) => switch (role) {
    ParticipantRole.host => 0,
    ParticipantRole.cohost => 1,
    ParticipantRole.listener => 2,
    _ => 999, // Unknown participant role should appear last,
  };

  void _handleSearchChange(String? query, ListenableSubscription _) {
    final isQueryEmpty = query == null || query.isEmpty;
    isSearching.value = !isQueryEmpty;

    if (!isQueryEmpty && displayedCount.value < _maxWithoutViewAll) {
      displayedCount.value = _maxWithoutViewAll;
    }
  }

  @override
  FutureOr<dynamic> onDispose() async {
    await _onParticipantJoined?.cancel();
    await _onParticipantLeft?.cancel();

    _onParticipantJoined = null;
    _onParticipantLeft = null;

    _sortedParticipants.dispose();
    recentParticipants.dispose();
    searchQuery.dispose();
    isSearching.dispose();
    displayedCount.dispose();
    allTimeCount.dispose();

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

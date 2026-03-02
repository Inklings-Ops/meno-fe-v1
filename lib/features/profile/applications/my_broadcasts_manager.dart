import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/shared/shared.dart';

class MyBroadcastsManager with MLogger implements Disposable {
  MyBroadcastsManager({
    required IBroadcastFeedSource broadcastFeedSource,
    required Id currentUserId,
  }) : _broadcastFeedSource = broadcastFeedSource,
       _currentUserId = currentUserId;

  final IBroadcastFeedSource _broadcastFeedSource;
  final Id _currentUserId;

  late final pagedList = ValueNotifier(const PagedList<Broadcast?>.empty());

  late final error = ValueNotifier<MenoException?>(null);

  late final _query = ValueNotifier(
    BroadcastQuery.byCreator(creatorId: _currentUserId),
  );

  StreamSubscription<Broadcast>? _newBroadcastSub;
  StreamSubscription<EndedBroadcast>? _endedBroadcastSub;

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final result = await _broadcastFeedSource.getBroadcasts(_query.value);
    result.fold(
      (failure) => error.value = failure,
      (page) => pagedList.value = page,
    );
  }, errorFilterFn: menoExceptionFilter);

  late final fetchMore = Command.createAsyncNoParamNoResult(() async {
    final nextQuery = _query.value.nextPage();
    final result = await _broadcastFeedSource.getBroadcasts(nextQuery);
    result.fold((failure) => error.value = failure, pagedList.value.merge);
  }, errorFilterFn: menoExceptionFilter);

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    _newBroadcastSub = _broadcastFeedSource.onBroadcastStarted.listen((event) {
      final currentBroadcasts = List<Broadcast?>.from(pagedList.value.items);
      final exists = currentBroadcasts.any((e) => e?.id == event.id);
      if (!exists) {
        currentBroadcasts.insert(0, event);
        pagedList.value = pagedList.value.copyWith(items: currentBroadcasts);
      }
    });
    _endedBroadcastSub = _broadcastFeedSource.onBroadcastEnded.listen((event) {
      final endedBroadcast = event.details;
      final currentBroadcasts = List<Broadcast?>.from(pagedList.value.items);
      final exists = currentBroadcasts.any((e) => e?.id == endedBroadcast.id);
      if (!exists) {
        currentBroadcasts.insert(0, endedBroadcast);
        pagedList.value = pagedList.value.copyWith(items: currentBroadcasts);
      }
    });
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(fetch);

  late final isFetching = initialize.isRunning.combineLatest(
    fetch.isRunning,
    (a, b) => a || b,
  );

  @override
  FutureOr<dynamic> onDispose() async {
    await _newBroadcastSub?.cancel();
    _newBroadcastSub = null;

    await _endedBroadcastSub?.cancel();
    _endedBroadcastSub = null;

    pagedList.dispose();

    initialize.dispose();
    fetch.dispose();
    fetchMore.dispose();
  }
}

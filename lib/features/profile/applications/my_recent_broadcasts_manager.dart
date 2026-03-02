import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/shared/domain/broadcast_query.dart';
import 'package:meno/shared/domain/i_broadcast_feed_source.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class MyRecentBroadcastsManager with MLogger implements Disposable {
  MyRecentBroadcastsManager({
    required IBroadcastFeedSource broadcastFeedSource,
    required Id currentUserId,
  }) : _broadcastFeedSource = broadcastFeedSource,
       _currentUserId = currentUserId;

  final IBroadcastFeedSource _broadcastFeedSource;
  final Id _currentUserId;

  late final broadcasts = ListNotifier<Broadcast?>(data: []);
  StreamSubscription? _subscription;

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final query = BroadcastQuery.recentlyLive(creatorId: _currentUserId);
    final result = await _broadcastFeedSource.getBroadcasts(query);
    result.fold((error) => throw error, (page) {
      broadcasts.startTransAction();
      broadcasts.clear();
      broadcasts.addAll(page.items);
      broadcasts.endTransAction();
    });
  }, errorFilterFn: menoExceptionFilter);

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    _subscription = _broadcastFeedSource.onBroadcastEnded.listen((incoming) {
      final incomingBroadcast = incoming.details;
      final exists = broadcasts.any((e) => e?.id == incomingBroadcast.id);
      if (!exists) broadcasts.insert(0, incomingBroadcast);
    });
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(fetch);

  @override
  FutureOr<dynamic> onDispose() async {
    await _subscription?.cancel();
    _subscription = null;

    broadcasts.dispose();

    initialize.dispose();
    fetch.dispose();
  }
}

import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/shared/domain/broadcast_query.dart';
import 'package:meno/shared/domain/i_broadcast_feed_source.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class ProfileRecentBroadcastsManager with MLogger implements Disposable {
  ProfileRecentBroadcastsManager({
    required IBroadcastFeedSource broadcastFeedSource,
    required Id userId,
  }) : _broadcastFeedSource = broadcastFeedSource,
       _userId = userId;

  final IBroadcastFeedSource _broadcastFeedSource;
  final Id _userId;

  late final broadcasts = ListNotifier<Broadcast?>(data: []);

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final query = BroadcastQuery.recentlyLive(creatorId: _userId);
    final result = await _broadcastFeedSource.getBroadcasts(query);
    result.fold((error) => throw error, (page) {
      broadcasts.startTransAction();
      broadcasts.clear();
      broadcasts.addAll(page.items);
      broadcasts.endTransAction();
    });
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() async {
    broadcasts.dispose();

    fetch.dispose();
  }
}

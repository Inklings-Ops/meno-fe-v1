import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/model/model.dart';
import 'package:meno/features/broadcast/broadcast.dart';

final class NowLiveBroadcastManager implements Disposable {
  NowLiveBroadcastManager(this._http, this._socket);

  final BroadcastHttpService _http;
  final BroadcastSocketService _socket;

  final broadcasts = ListNotifier<Broadcast?>(data: []);

  StreamSubscription<Broadcast>? _newBroadcastSubscription;
  StreamSubscription<EndedBroadcast>? _endedroadcastSubscription;

  late final initialize = Command.createSyncNoParamNoResult(() {
    _newBroadcastSubscription?.cancel();
    _newBroadcastSubscription = null;

    _endedroadcastSubscription?.cancel();
    _endedroadcastSubscription = null;

    _newBroadcastSubscription = _socket.onNewBroadcast.listen((incoming) {
      final exists = broadcasts.any((b) => b?.id == incoming.id);
      if (!exists) broadcasts.insert(0, incoming);
    });

    _endedroadcastSubscription = _socket.onEndedBroadcast.listen((incoming) {
      broadcasts.removeWhere((b) => b?.id == incoming.details.id);
    });
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(_fetchBroadcasts);

  late final _fetchBroadcasts = Command.createAsyncNoParamNoResult(() async {
    final query = BroadcastQuery.nowLive();
    final page = await _http.getBroadcasts(query);
    broadcasts.startTransAction();
    broadcasts.clear();
    broadcasts.addAll(page.items);
    broadcasts.endTransAction();
  }, errorFilterFn: menoExceptionFilter);

  late final isInitializing = initialize.isRunning.combineLatest(
    _fetchBroadcasts.isRunning,
    (initializing, fetching) => initializing || fetching,
  );

  @override
  FutureOr<dynamic> onDispose() {
    _newBroadcastSubscription?.cancel();
    _newBroadcastSubscription = null;

    _endedroadcastSubscription?.cancel();
    _endedroadcastSubscription = null;

    broadcasts.dispose();

    initialize.dispose();
    _fetchBroadcasts.dispose();
  }
}

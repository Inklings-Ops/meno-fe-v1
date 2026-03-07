import 'dart:async';

import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';

class LiveFeedDataSource extends BroadcastFeedDataSource {
  LiveFeedDataSource({
    required super.http,
    required BroadcastSocketService socket,
    required BroadcastQuery query,
  }) : _socket = socket,
       super(initialQuery: query) {
    _newBroadcastSub = _socket.onNewBroadcast.listen(prependFromSocket);

    _endedBroadcastSub = _socket.onEndedBroadcast.listen(removeOnEnded);
  }

  final BroadcastSocketService _socket;

  StreamSubscription<Broadcast>? _newBroadcastSub;
  StreamSubscription<EndedBroadcast>? _endedBroadcastSub;

  @override
  FutureOr<dynamic> onDispose() {
    _newBroadcastSub?.cancel();
    _endedBroadcastSub?.cancel();
    super.onDispose();
  }
}

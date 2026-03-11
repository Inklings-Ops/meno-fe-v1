import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_di/live_scope_locator.dart';
import 'package:meno/features/broadcast/broadcast.dart';

final class StreamManager with MLogger implements Disposable {
  StreamManager({
    required BroadcastHttpService http,
    required BroadcastLocalService local,
    required Id currentUserId,
  }) : _http = http,
       _local = local,
       _currentUserId = currentUserId;

  final BroadcastHttpService _http;
  final BroadcastLocalService _local;
  final Id _currentUserId;

  late final joinBroadcast = Command.createAsync<Id, Broadcast>(
    _http.joinBroadcast,
    initialValue: Broadcast.empty,
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(saveBroadcastSession, transform: (value) => value);

  late final saveBroadcastSession = Command.createAsync<Broadcast, Broadcast>(
    (broadcast) async {
      final session = BroadcastSession.create(_currentUserId, broadcast);
      await _local.saveBroadcastSession(_currentUserId, session);
      await pushLiveSessionScope(session);
      return broadcast;
    },
    initialValue: Broadcast.empty,
    errorFilterFn: menoExceptionFilter,
  );

  late final isRunning = joinBroadcast.isRunning.combineLatest(
    saveBroadcastSession.isRunning,
    (isJoining, isSaving) => isJoining || isSaving,
  );

  @override
  FutureOr<dynamic> onDispose() {
    joinBroadcast.dispose();
    saveBroadcastSession.dispose();
  }
}

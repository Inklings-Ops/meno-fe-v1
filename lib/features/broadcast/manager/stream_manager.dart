import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/broadcast/broadcast.dart';

class StreamManager with MLogger implements Disposable {
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

  final broadcast = ValueNotifier<Broadcast>(.empty);

  late final fetchBroadcast = Command.createAsyncNoResult<Id>((id) async {
    final result = await _http.getBroadcast(id);
    broadcast.value = result;
  }, errorFilterFn: menoExceptionFilter);

  late final joinBroadcast = Command.createAsync<Id, Broadcast>(
    _http.joinBroadcast,
    initialValue: Broadcast.empty,
    errorFilterFn: menoExceptionFilter,
  )..pipeToCommand(saveBroadcastSession, transform: (value) => value);

  late final saveBroadcastSession = Command.createAsync<Broadcast, Broadcast>(
    (broadcast) async {
      final session = BroadcastSession.create(_currentUserId, broadcast);
      await _local.saveBroadcastSession(_currentUserId, session);
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
    broadcast.dispose();

    fetchBroadcast.dispose();
    joinBroadcast.dispose();
    saveBroadcastSession.dispose();
  }
}

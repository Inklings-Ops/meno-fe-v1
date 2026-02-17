import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/applications/live_session_manager.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/chat/domain/domain.dart';

class ChatListManager with MLogger implements Disposable {
  ChatListManager({
    required IChatRepository repository,
    required BroadcastSession session,
  }) : _repository = repository,
       _session = session;

  final IChatRepository _repository;
  final BroadcastSession _session;

  late final messages = ValueNotifier<List<Message>>([]);

  StreamSubscription<List<Message>>? _subscription;

  bool _isInitialized = false;

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    if (_isInitialized) {
      log.w('ParticipantsManager: Already initialized');
      return;
    }

    log.d('ChatListManager: Waiting for LiveSessionManager...');
    await di.isReady<LiveSessionManager>();

    log.d('ChatListManager: Initializing');

    await _subscription?.cancel();
    _subscription = null;

    final broadcastId = _session.broadcast.id;
    _subscription = _repository
        .watchMessages(broadcastId)
        .listen((data) => messages.value = data);

    _isInitialized = true;
    log.d('ChatListManager: Initialized');
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    log.d('ChatListManager: Disposed');
    _subscription?.cancel();
    messages.dispose();
  }
}

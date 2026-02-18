import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/applications/live_session_manager.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/features/chat/infrastructure/infrastructure.dart';

class ChatListManager with MLogger implements Disposable {
  ChatListManager({
    required IChatRepository repository,
    required BroadcastSession session,
  }) : _repository = repository,
       _session = session;

  final IChatRepository _repository;
  final BroadcastSession _session;

  final messages = ValueNotifier<List<Message>>([]);
  final isFetchingOlder = ValueNotifier(false);
  final hasReachedEnd = ValueNotifier(false);

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
    _subscription = _repository.watchMessages(broadcastId).listen((data) {
      messages.value = data;
      hasReachedEnd.value = !_repository.canFetchMore;
    }, onError: (Object e) => log.e('ChatListManager: Stream error — $e'));

    _isInitialized = true;
    log.d('ChatListManager: Initialized');
  }, errorFilterFn: menoExceptionFilter);

  late final fetchOlderMessages = Command.createAsyncNoParamNoResult(
    () async {
      if (isFetchingOlder.value || !_repository.canFetchMore) return;

      isFetchingOlder.value = true;
      final res = await _repository.fetchOlderMessages(_session.broadcast.id);
      return res.fold((failure) => throw failure, (_) {
        isFetchingOlder.value = false;
        hasReachedEnd.value = !_repository.canFetchMore;
      });
    },
    errorFilterFn: menoExceptionFilter,
    restriction: isFetchingOlder.map((value) => !value),
  );

  late final deleteMessage = Command.createAsyncNoResult((
    Message message,
  ) async {
    if (!message.isDeletable) return;

    final params = DeleteMessageParams(
      id: message.id.getOrCrash(),
      senderId: message.effectiveSenderId.getOrCrash(),
      broadcastId: message.broadcastId.getOrCrash(),
      content: message.content.getOrCrash(),
      createdAt: message.createdAt,
    );

    final result = await _repository.deleteMessage(params);
    return result.fold((failure) => throw failure, (_) {});
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    log.d('ChatListManager: Disposed');
    _subscription?.cancel();

    initialize.dispose();
    fetchOlderMessages.dispose();
    deleteMessage.dispose();

    messages.dispose();
    hasReachedEnd.dispose();
    isFetchingOlder.dispose();
  }
}

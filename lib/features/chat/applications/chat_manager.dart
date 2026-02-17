import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/chat/domain/domain.dart';
import 'package:meno/features/chat/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

class ChatManager with MLogger implements Disposable {
  ChatManager({
    required IChatRepository repository,
    required Id broadcastId,
    required Id currentUserId,
  }) : _repository = repository,
       _broadcastId = broadcastId,
       _currentUserId = currentUserId;

  final IChatRepository _repository;
  final Id _broadcastId;
  final Id _currentUserId;

  late final content = ValueNotifier(MultiLineString.empty);

  late final welcomeMessageVisible = ValueNotifier(true);

  void onContentChange(String value) => content.value = MultiLineString(value);

  void hideWelcomeNote() => welcomeMessageVisible.value = false;

  late final sendMessage = Command.createSyncNoParamNoResult(
    () async {
      final params = NewMessageParams(
        senderId: _currentUserId.getOrCrash(),
        broadcastId: _broadcastId.getOrCrash(),
        content: content.value.getOrCrash(),
        createdAt: DateTime.now(),
      );
      await _repository.sendMessage(params);
      content.value = MultiLineString.empty;
    },
    errorFilterFn: menoExceptionFilter,
    restriction: content.map((value) => !value.isValid),
  );

  @override
  FutureOr<dynamic> onDispose() {
    log.d('ChatManager: Disposed');
    content.dispose();
    welcomeMessageVisible.dispose();
    sendMessage.dispose();
  }
}

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

  late final messageToEdit = ValueNotifier<Message?>(null);

  late final welcomeMessageVisible = ValueNotifier(true);

  void onContentChange(String value) => content.value = MultiLineString(value);

  void hideWelcomeNote() => welcomeMessageVisible.value = false;

  late final sendMessage = Command.createAsyncNoParamNoResult(
    () async {
      final params = NewMessageParams(
        senderId: _currentUserId.getOrCrash(),
        broadcastId: _broadcastId.getOrCrash(),
        content: content.value.getOrCrash(),
        createdAt: DateTime.now(),
      );
      final result = await _repository.sendMessage(params);
      return result.fold((failure) => throw failure, (_) {
        content.value = MultiLineString.empty;
      });
    },
    errorFilterFn: menoExceptionFilter,
    restriction: content.map((value) => !value.isValid),
  );

  late final startEditing = Command.createSyncNoResult<Message>((message) {
    messageToEdit.value = message;
    content.value = message.content;
  });

  late final stopEditing = Command.createSyncNoParamNoResult(() {
    messageToEdit.value = null;
    content.value = MultiLineString.empty;
  });

  late final editMessage = Command.createAsyncNoParamNoResult(
    () async {
      final message = messageToEdit.value;
      if (message == null || !message.isEditable) return;

      final params = EditMessageParams(
        id: message.id.getOrCrash(),
        senderId: message.effectiveSenderId.getOrCrash(),
        broadcastId: message.broadcastId.getOrCrash(),
        content: content.value.getOrCrash(),
        createdAt: message.createdAt,
        updatedAt: message.updatedAt,
      );

      final result = await _repository.editMessage(params);
      return result.fold((failure) => throw failure, (_) {
        messageToEdit.value = null;
        content.value = MultiLineString.empty;
      });
    },
    errorFilterFn: menoExceptionFilter,
    restriction: messageToEdit.map((value) => value != null),
  );

  late final isEditing = messageToEdit.map((value) => value != null);

  @override
  FutureOr<dynamic> onDispose() {
    log.d('ChatManager: Disposed');

    content.dispose();
    messageToEdit.dispose();
    welcomeMessageVisible.dispose();

    sendMessage.dispose();
    startEditing.dispose();
    stopEditing.dispose();
    editMessage.dispose();
  }
}

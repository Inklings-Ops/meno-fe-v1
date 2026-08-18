import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/broadcast/model/entities/broadcast_session.dart';
import 'package:meno/features/chat/model/_model.dart';
import 'package:meno/features/chat/services/chat_socket_service.dart';

final class ChatManager with MLogger implements Disposable {
  ChatManager({
    required ChatSocketService socket,
    required BroadcastSession session,
  }) : _socket = socket,
       _session = session;

  final ChatSocketService _socket;
  final BroadcastSession _session;

  final content = ValueNotifier(MultiLineString.empty);
  final messageToEdit = ValueNotifier<Message?>(null);
  final welcomeMessageVisible = ValueNotifier(true);

  late final isEditing = messageToEdit.map((m) => m != null);

  void onContentChange(String value) => content.value = MultiLineString(value);

  void hideWelcomeNote() => welcomeMessageVisible.value = false;

  late final sendMessage = Command.createAsyncNoParamNoResult(
    () async {
      final args = NewMessageArgs(
        senderId: _session.currentUserId.getOrCrash(),
        broadcastId: _session.broadcast.id.getOrCrash(),
        content: content.value.getOrCrash(),
        createdAt: .now(),
      );
      await _socket.emitSendChatMessage(args);
      content.value = .empty;
    },
    errorFilterFn: menoExceptionFilter,
    restriction: content.map((v) => !v.isValid),
  );

  late final startEditing = Command.createSyncNoResult<Message>((message) {
    messageToEdit.value = message;
    content.value = message.content;
  });

  late final stopEditing = Command.createSyncNoParamNoResult(() {
    messageToEdit.value = null;
    content.value = .empty;
  });

  late final editMessage = Command.createAsyncNoParamNoResult(
    () async {
      final message = messageToEdit.value;
      if (message == null || !message.isEditable) return;

      final args = EditMessageArgs(
        id: message.id.getOrCrash(),
        senderId: message.effectiveSenderId.getOrCrash(),
        broadcastId: message.broadcastId.getOrCrash(),
        content: content.value.getOrCrash(),
        createdAt: message.createdAt,
        updatedAt: .now(),
      );

      await _socket.emitEditMessage(args);
      messageToEdit.value = null;
      content.value = .empty;
    },
    errorFilterFn: menoExceptionFilter,
    restriction: messageToEdit.combineLatest(
      content,
      (m, c) => m == null || !c.isValid,
    ),
  );

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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/chat/model/_model.dart';
import 'package:meno/features/chat/services/chat_socket_service.dart';

class MessageProxy extends ChangeNotifier implements Disposable {
  MessageProxy(this._target);

  Message _target;

  Message get target => _target;

  int referenceCount = 0;

  set target(Message value) {
    _target = value;
    notifyListeners();
  }

  Id get id => _target.id;

  String get idStr => _target.id.getOrCrash();

  MultiLineString get content => _target.content;

  MessageSender? get sender => _target.sender;

  Id get senderId => _target.effectiveSenderId;

  SingleLineString get senderName => _target.effectiveSenderName;

  String? get imageUrl => _target.imageUrl;

  DateTime get createdAt => _target.createdAt;

  DateTime? get updatedAt => _target.updatedAt;

  MessageStatus get status => _target.status;

  bool get isEditable => _target.isEditable;

  bool get isDeletable => _target.isDeletable;

  bool get isSending => _target.status == MessageStatus.sending;

  bool get hasFailed => _target.status == MessageStatus.failed;

  late final deleteMessage = Command.createAsyncNoParamNoResult(() async {
    if (!_target.isDeletable) return;
    final args = DeleteMessageArgs(
      id: idStr,
      senderId: _target.effectiveSenderId.getOrCrash(),
      broadcastId: _target.broadcastId.getOrCrash(),
      content: _target.content.getOrCrash(),
      createdAt: _target.createdAt,
    );
    await di<ChatSocketService>().emitDeleteMessage(args);
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    deleteMessage.dispose();
    dispose();
  }
}

import 'dart:async';

import 'package:meno/_shared/services/socket_client.dart';
import 'package:meno/features/chat/model/model.dart';

final class ChatSocketService {
  const ChatSocketService(this._client);

  final SocketClient _client;

  Future<void> emitSendChatMessage(NewMessageArgs args) async {
    return _client.emitWithAck(.sendChatMessage, args.toJson());
  }

  Future<void> emitEditMessage(EditMessageArgs args) async {
    return _client.emitWithAck(.editChatMessage, args.toJson());
  }

  Future<void> emitDeleteMessage(DeleteMessageArgs args) async {
    return _client.emitWithAck(.deleteChatMessage, args.toJson());
  }

  Stream<MessageDto> onNewMessage(String broadcastId) {
    late StreamController<MessageDto> controller;
    SocketSubscription? subscription;

    controller = StreamController<MessageDto>.broadcast(
      onListen: () {
        subscription = _client.on(SocketEvent.newMessage, (dynamic data) {
          final dto = MessageDto.fromJson(data);
          controller.add(dto);
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  Stream<MessageDto> onEditedMessage(String broadcastId) {
    late StreamController<MessageDto> controller;
    SocketSubscription? subscription;

    controller = StreamController<MessageDto>.broadcast(
      onListen: () {
        subscription = _client.on(SocketEvent.editedMessage, (dynamic data) {
          final dto = MessageDto.fromJson(data);
          controller.add(dto);
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  Stream<MessageDto> onDeletedMessage(String broadcastId) {
    late StreamController<MessageDto> controller;
    SocketSubscription? subscription;

    controller = StreamController<MessageDto>.broadcast(
      onListen: () {
        subscription = _client.on(SocketEvent.deletedMessage, (dynamic data) {
          final dto = MessageDto.fromJson(data);
          controller.add(dto);
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/chat/infrastructure/dtos/message_dto.dart';
import 'package:meno/features/chat/infrastructure/new_message_params.dart';

class ChatRemoteDataSource with MLogger {
  const ChatRemoteDataSource({
    required ApiClient api,
    required WebSocketClient socket,
  }) : _api = api,
       _socket = socket;

  final ApiClient _api;
  final WebSocketClient _socket;

  Future<dynamic> getMessages(
    String broadcastId, {
    CancelToken? cancelToken,
    int page = 1,
    int size = 100,
  }) {
    return _api.get(
      '/chat-messages',
      fromJson: (json) => json,
      cancelToken: cancelToken,
      queryParameters: {
        'broadcastId': broadcastId,
        'page': page,
        'size': size,
        'order_by': 'desc',
      },
    );
  }

  Future<void> emitSendChatMessage(NewMessageParams params) async {
    return _socket.emitWithAck(.sendChatMessage, params.toJson());
  }

  Future<void> emitEditMessage(EditMessageParams params) async {
    return _socket.emitWithAck(.editChatMessage, params.toJson());
  }

  Future<void> emitDeleteMessage(DeleteMessageParams params) async {
    return _socket.emitWithAck(.deleteChatMessage, params.toJson());
  }

  Stream<MessageDto> onNewMessage(String broadcastId) {
    late StreamController<MessageDto> controller;
    SocketSubscription? subscription;

    controller = StreamController<MessageDto>.broadcast(
      onListen: () {
        subscription = _socket.on(SocketEvent.newMessage, (dynamic data) {
          try {
            final dto = MessageDto.fromJson(data);
            controller.add(dto);
          } catch (e) {
            log.e('Error parsing newMessage: $e');
          }
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
        subscription = _socket.on(SocketEvent.editedMessage, (dynamic data) {
          try {
            final dto = MessageDto.fromJson(data);
            controller.add(dto);
          } catch (e) {
            log.e('Error parsing editedMessage: $e');
          }
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
        subscription = _socket.on(SocketEvent.deletedMessage, (dynamic data) {
          try {
            final dto = MessageDto.fromJson(data);
            controller.add(dto);
          } catch (e) {
            log.e('Error parsing deletedMessage: $e');
          }
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }
}

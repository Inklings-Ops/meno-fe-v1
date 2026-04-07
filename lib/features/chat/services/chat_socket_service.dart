import 'dart:async';

import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/services/socket_client.dart';
import 'package:meno/features/chat/model/_model.dart';

final class ChatSocketService with MLogger {
  const ChatSocketService(this._client);

  final SocketClient _client;

  Future<PagedList<Message>> emitGetChatMessages(String broadcastId) async {
    final response = await _client.emitWithAck(SocketEvent.getChatMessages, {
      'broadcastId': broadcastId,
      'orderBy': 'desc',
    });
    log.f('ChatSocketService: $response');
    return PagedList.fromJson(
      (response as Map<String, dynamic>)['data'],
      (jsonT) => MessageDto.fromJson(jsonT).toDomain,
      listKey: 'chatMessages',
    );
  }

  Future<void> emitSendChatMessage(NewMessageArgs args) async {
    return _client.emitWithAck(.sendChatMessage, args.toJson());
  }

  Future<void> emitEditMessage(EditMessageArgs args) async {
    return _client.emitWithAck(.editChatMessage, args.toJson());
  }

  Future<void> emitDeleteMessage(DeleteMessageArgs args) async {
    return _client.emitWithAck(.deleteChatMessage, args.toJson());
  }

  Stream<MessageDto> get onNewMessage => _messageStream(.newMessage);

  Stream<MessageDto> get onEditedMessage => _messageStream(.editedMessage);

  Stream<MessageDto> get onDeletedMessage => _messageStream(.deletedMessage);

  Stream<void> get onReconnected =>
      _client.connectionState.where((s) => s == .connected).map((_) {});

  // =========================================================================
  // PRIVATE
  // =========================================================================

  /// Single shared broadcast stream per socket event type.
  /// All where filters above are cheap downstream operations on this stream.
  Stream<MessageDto> _messageStream(SocketEvent event) {
    late StreamController<MessageDto> controller;
    SocketSubscription? subscription;

    controller = StreamController<MessageDto>.broadcast(
      onListen: () {
        subscription = _client.on(event, (dynamic data) {
          final dto = MessageDto.fromJson(data);
          log.f('ChatSocketService: ${event.name}: ${dto.content}');
          controller.add(dto);
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }
}

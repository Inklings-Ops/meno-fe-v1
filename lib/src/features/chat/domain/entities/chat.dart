import 'package:freezed_annotation/freezed_annotation.dart';

import '../inputs/inputs.dart';

part 'chat.freezed.dart';

@freezed
class Chat with _$Chat {
  factory Chat({
    required String id,
    required IChatContent content,
    required DateTime createdAt,
    DateTime? updatedAt,
    required String senderId,
    required String broadcastId,
  }) = _Chat;

  factory Chat.empty() {
    return Chat(
      id: "",
      content: IChatContent(""),
      createdAt: DateTime.now(),
      updatedAt:  null,
      senderId: "",
      broadcastId: "",
    );
  }
}

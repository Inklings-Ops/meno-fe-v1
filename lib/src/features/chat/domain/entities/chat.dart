import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/chat/domain/inputs/inputs.dart';

part 'chat.freezed.dart';

@freezed
class Chat with _$Chat {
  factory Chat({
    required String id,
    required IChatContent content,
    required DateTime createdAt,
    required String senderId, required String fullName, required String broadcastId, DateTime? updatedAt,
    String? imageUrl,
  }) = _Chat;

  factory Chat.empty() {
    return Chat(
      id: '',
      content: IChatContent(''),
      createdAt: DateTime.now(),
      senderId: '',
      broadcastId: '',
      fullName: '',
      imageUrl: '',
    );
  }
}

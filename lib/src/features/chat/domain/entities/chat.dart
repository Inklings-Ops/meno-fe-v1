import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';


part 'chat.freezed.dart';

@freezed
class Chat with _$Chat {
  factory Chat({
    required String id,
    required IChatContent content,
    required DateTime createdAt,
    required String broadcastId,
    ChatSender? sender,
    String? senderId,
    String? fullName,
    String? imageUrl,
    DateTime? updatedAt,
  }) = _Chat;

  factory Chat.empty() {
    return Chat(
      id: '',
      content: IChatContent(''),
      createdAt: DateTime.now(),
      sender: null,
      senderId: '',
      broadcastId: '',
      fullName: '',
      imageUrl: '',
    );
  }
}

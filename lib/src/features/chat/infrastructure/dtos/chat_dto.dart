import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

part 'chat_dto.freezed.dart';
part 'chat_dto.g.dart';

@freezed
@JsonSerializable(createFactory: false)
class ChatDto with _$ChatDto {
  factory ChatDto({
    required String id,
    required String content,
    required DateTime createdAt,
    required String broadcastId,
    ChatSenderDto? sender,
    String? senderId,
    String? fullName,
    String? imageUrl,
    DateTime? updatedAt,
  }) = _ChatDto;

  factory ChatDto.fromJson(Map<String, dynamic> json) =>
      _$ChatDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChatDtoToJson(this);
}

extension ChatDtoToDomain on ChatDto {
  Chat get toDomain {
    return Chat(
      id: id,
      content: IChatContent(content),
      createdAt: createdAt,
      sender: sender?.toDomain,
      senderId: senderId,
      broadcastId: broadcastId,
      updatedAt: updatedAt,
      imageUrl: imageUrl,
      fullName: fullName,
    );
  }
}

extension ChatToDto on Chat {
  ChatDto get toDto {
    return ChatDto(
      id: id,
      content: content.getOr(),
      createdAt: createdAt,
      sender: sender?.toDto,
      senderId: senderId,
      broadcastId: broadcastId,
      updatedAt: updatedAt,
      imageUrl: imageUrl,
      fullName: fullName,
    );
  }
}

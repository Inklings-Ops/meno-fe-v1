import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

part 'chat_list_dto.freezed.dart';
part 'chat_list_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class ChatListDto with _$ChatListDto {
  factory ChatListDto({
    required List<ChatDto?> chatMessages,
    required int totalItems,
    required int totalPages,
    required int currentPage,
  }) = _ChatListDto;

  factory ChatListDto.fromJson(Map<String, dynamic> json) =>
      _$ChatListDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChatListDtoToJson(this);
}

extension ChatListDtoToDomain on ChatListDto {
  ChatListEntity get toDomain => ChatListEntity(
        chatMessages: chatMessages.map((c) => c?.toDomain).toList(),
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: currentPage,
      );
}

extension ChatListToDto on ChatListEntity {
  ChatListDto get toDto => ChatListDto(
        chatMessages: chatMessages.map((c) => c?.toDto).toList(),
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: currentPage,
      );
}

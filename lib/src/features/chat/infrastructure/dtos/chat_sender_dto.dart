import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

part 'chat_sender_dto.freezed.dart';
part 'chat_sender_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class ChatSenderDto with _$ChatSenderDto {
  factory ChatSenderDto({
    required String id,
    required String fullName,
    String? imageUrl,
  }) = _ChatSenderDto;

  factory ChatSenderDto.fromJson(Map<String, dynamic> json) =>
      _$ChatSenderDtoFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ChatSenderDtoToJson(this);
}

extension ChatSenderDtoToDomain on ChatSenderDto {
  ChatSender get toDomain => ChatSender(
        id: id,
        fullName: fullName,
        imageUrl: imageUrl,
      );
}

extension ChatSenderToDto on ChatSender {
  ChatSenderDto get toDto => ChatSenderDto(
        id: id,
        fullName: fullName,
        imageUrl: imageUrl,
      );
}

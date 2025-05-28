import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/chat/domain/domain.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'chat_sender_dto.g.dart';

@JsonSerializable()
final class ChatSenderDto with EquatableMixin {
  const ChatSenderDto({
    required this.id,
    required this.fullName,
    this.imageUrl,
  });

  factory ChatSenderDto.fromJson(Map<String, dynamic> json) =>
      _$ChatSenderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSenderDtoToJson(this);

  final String id;
  final String fullName;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, fullName, imageUrl];
}

extension ChatSenderToDto on ChatSender {
  ChatSenderDto get toDto {
    return ChatSenderDto(
      id: id.getOrCrash(),
      fullName: fullName.getOrCrash(),
      imageUrl: imageUrl,
    );
  }
}

extension ChatSenderToDomain on ChatSenderDto {
  ChatSender get toDomain {
    return ChatSender(
      id: ID.fromString(id),
      fullName: SingleLineString(fullName),
      imageUrl: imageUrl,
    );
  }
}

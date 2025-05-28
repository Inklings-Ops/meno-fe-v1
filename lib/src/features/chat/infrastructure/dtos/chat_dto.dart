import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/chat/domain/domain.dart';
import 'package:meno_fe_v1/src/features/chat/infrastructure/infrastructure.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'chat_dto.g.dart';

@JsonSerializable()
final class ChatDto with EquatableMixin {
  const ChatDto({
    required this.id,
    required this.content,
    required this.broadcastId,
    required this.createdAt,
    this.sender,
    this.senderId,
    this.fullName,
    this.imageUrl,
    this.updatedAt,
    this.status = ChatStatus.sending,
  });

  factory ChatDto.fromJson(Map<String, dynamic> json) =>
      _$ChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDtoToJson(this);

  final String id;
  final String content;
  final ChatSenderDto? sender;
  final String? senderId;
  final String? fullName;
  final String? imageUrl;
  final String broadcastId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ChatStatus status;

  @override
  List<Object?> get props => [
    id,
    content,
    sender,
    senderId,
    fullName,
    imageUrl,
    broadcastId,
    createdAt,
    updatedAt,
    status,
  ];
}

extension ChatToDto on Chat {
  ChatDto get toDto {
    return ChatDto(
      id: id.getOrCrash(),
      content: content.getOrCrash(),
      broadcastId: broadcastId.getOrCrash(),
      createdAt: createdAt,
      sender: sender?.toDto,
      senderId: senderId?.getOrNull(),
      fullName: fullName?.getOrNull(),
      imageUrl: imageUrl,
      updatedAt: updatedAt,
      status: status,
    );
  }
}

extension ChatToDomain on ChatDto {
  Chat get toDomain {
    return Chat(
      id: ID.fromString(id),
      content: MultiLineString(content),
      sender: sender?.toDomain,
      senderId: senderId != null ? ID.fromString(senderId!) : null,
      fullName: fullName != null ? SingleLineString(fullName!) : null,
      imageUrl: imageUrl,
      broadcastId: ID.fromString(broadcastId),
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
    );
  }
}

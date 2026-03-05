import 'package:equatable/equatable.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/chat/model/dtos/message_sender_dto.dart';
import 'package:meno/features/chat/model/entities/entities.dart';

final class MessageDto with EquatableMixin {
  const MessageDto({
    required this.id,
    required this.content,
    required this.broadcastId,
    required this.createdAt,
    this.sender,
    this.senderId,
    this.fullName,
    this.imageUrl,
    this.updatedAt,
    this.status = MessageStatus.sending,
  });

  factory MessageDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw FormatError<MessageDto>();
    return MessageDto(
      id: json[_kId] as String,
      content: json[_kContent] as String,
      broadcastId: json[_kBroadcastId] as String,
      createdAt: DateTime.parse(json[_kCreatedAt] as String),
      sender: json[_kSender] != null
          ? MessageSenderDto.fromJson(json[_kSender])
          : null,
      senderId: json[_kSenderId] as String?,
      fullName: json[_kFullName] as String?,
      imageUrl: json[_kImageUrl] as String?,
      updatedAt: json[_kUpdatedAt] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  final String id;
  final String content;
  final MessageSenderDto? sender;
  final String? senderId;
  final String? fullName;
  final String? imageUrl;
  final String broadcastId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final MessageStatus status;

  static const String _kId = 'id';
  static const String _kContent = 'content';
  static const String _kSender = 'sender';
  static const String _kSenderId = 'senderId';
  static const String _kFullName = 'fullName';
  static const String _kImageUrl = 'imageUrl';
  static const String _kBroadcastId = 'broadcastId';
  static const String _kCreatedAt = 'createdAt';
  static const String _kUpdatedAt = 'updatedAt';

  // static const String _kStatus = 'status';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kContent: content,
    _kSender: sender,
    _kSenderId: senderId,
    _kFullName: fullName,
    _kImageUrl: imageUrl,
    _kBroadcastId: broadcastId,
    _kCreatedAt: createdAt.toIso8601String(),
    _kUpdatedAt: updatedAt?.toIso8601String(),
  };

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

extension MessageToDtoX on Message {
  MessageDto get toDto {
    return MessageDto(
      id: id.getOrCrash(),
      content: content.getOrCrash(),
      sender: sender?.toDto,
      senderId: senderId?.getOrCrash(),
      fullName: fullName?.getOrCrash(),
      imageUrl: imageUrl,
      broadcastId: broadcastId.getOrCrash(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
    );
  }
}

extension MessageToDomainX on MessageDto {
  Message get toDomain {
    return Message(
      id: Id.fromString(id),
      content: MultiLineString(content),
      sender: sender?.toDomain,
      senderId: senderId != null ? Id.fromString(senderId!) : null,
      fullName: fullName != null ? SingleLineString(fullName!) : null,
      imageUrl: imageUrl,
      broadcastId: Id.fromString(broadcastId),
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
    );
  }
}

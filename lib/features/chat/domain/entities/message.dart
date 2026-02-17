import 'package:equatable/equatable.dart';
import 'package:meno/features/chat/domain/entities/message_sender.dart';
import 'package:meno/shared/domain/domain.dart';

final class Message with EquatableMixin {
  const Message({
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

  final Id id;
  final MultiLineString content;
  final MessageSender? sender;
  final Id? senderId;
  final SingleLineString? fullName;
  final String? imageUrl;
  final Id broadcastId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final MessageStatus status;

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

  Message copyWith({
    Id? id,
    MultiLineString? content,
    MessageSender? sender,
    Id? senderId,
    SingleLineString? fullName,
    String? imageUrl,
    Id? broadcastId,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      senderId: senderId ?? this.senderId,
      fullName: fullName ?? this.fullName,
      imageUrl: imageUrl ?? this.imageUrl,
      broadcastId: broadcastId ?? this.broadcastId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  Id get effectiveSenderId => senderId ?? sender?.id ?? Id.empty;

  SingleLineString get effectiveSenderName =>
      fullName ?? sender?.fullName ?? SingleLineString.empty;
}

enum MessageStatus {
  /// Indicates the message is being sent or is pending delivery
  sending('sending'),

  /// Indicates the message has been sent or delivered
  sent('sent'),

  /// Indicates the message could not be delivered due to an error
  failed('failed');

  const MessageStatus(this.value);

  final String value;
}

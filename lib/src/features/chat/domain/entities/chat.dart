import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/chat/domain/entities/chat_sender.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

enum ChatStatus {
  /// Indicates the message is being sent or is pending delivery
  sending,

  /// Indicates the message has been sent or delivered
  sent,

  /// Indicates the message could not be delivered due to an error
  failed,
}

final class Chat with EquatableMixin {
  const Chat({
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

  final ID id;
  final MultiLineString content;
  final ChatSender? sender;
  final ID? senderId;
  final SingleLineString? fullName;
  final String? imageUrl;
  final ID broadcastId;
  final DateTime createdAt;
  final DateTime? updatedAt;
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

  Chat copyWith({
    ID? id,
    MultiLineString? content,
    ChatSender? sender,
    ID? senderId,
    SingleLineString? fullName,
    String? imageUrl,
    ID? broadcastId,
    DateTime? createdAt,
    DateTime? updatedAt,
    ChatStatus? status,
  }) {
    return Chat(
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
}

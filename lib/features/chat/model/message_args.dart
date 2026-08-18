sealed class MessageArgs {
  const MessageArgs({
    required this.senderId,
    required this.broadcastId,
    required this.content,
    required this.createdAt,
    this.id,
    this.updatedAt,
  });

  final String? id;
  final String senderId;
  final String broadcastId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  static const String _kId = 'id';
  static const String _kSenderId = 'senderId';
  static const String _kBroadcastId = 'broadcastId';
  static const String _kContent = 'content';
  static const String _kCreatedAt = 'createdAt';
  static const String _kUpdatedAt = 'updatedAt';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kSenderId: senderId,
    _kBroadcastId: broadcastId,
    _kContent: content,
    _kCreatedAt: createdAt.toIso8601String(),
    _kUpdatedAt: updatedAt?.toIso8601String(),
  };
}

class NewMessageArgs extends MessageArgs {
  const NewMessageArgs({
    required super.senderId,
    required super.broadcastId,
    required super.content,
    required super.createdAt,
  });
}

class EditMessageArgs extends MessageArgs {
  const EditMessageArgs({
    required super.id,
    required super.senderId,
    required super.broadcastId,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
  });
}

class DeleteMessageArgs extends MessageArgs {
  const DeleteMessageArgs({
    required super.id,
    required super.senderId,
    required super.broadcastId,
    required super.content,
    required super.createdAt,
  });
}

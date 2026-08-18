import 'package:equatable/equatable.dart';
import 'package:meno/features/notifications/models/entities/_entities.dart';

final class Notification with EquatableMixin {
  const Notification({
    this.read = false,
    this.id,
    this.type,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final NotificationType? type;
  final bool read;
  final NotificationContent? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Notification copyWith({
    String? id,
    NotificationType? type,
    bool? read,
    NotificationContent? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      read: read ?? this.read,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, type, read, content, createdAt, updatedAt];
}

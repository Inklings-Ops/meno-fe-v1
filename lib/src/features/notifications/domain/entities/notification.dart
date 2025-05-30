import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_content.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_type.dart';

final class Notification with EquatableMixin {
  const Notification({
    this.read = false,
    this.id,
    this.type,
    this.content,
    this.createdAt,
  });

  final String? id;
  final NotificationType? type;
  final bool read;
  final NotificationContent? content;
  final DateTime? createdAt;
  Notification copyWith({
    String? id,
    NotificationType? type,
    bool? read,
    NotificationContent? content,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      read: read ?? this.read,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, type, read, content, createdAt];
}

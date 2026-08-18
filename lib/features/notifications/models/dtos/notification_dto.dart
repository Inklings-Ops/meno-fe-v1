import 'package:meno/_core/_core.dart';
import 'package:meno/features/notifications/models/dtos/notification_content_dto.dart';
import 'package:meno/features/notifications/models/entities/_entities.dart';

class NotificationDto {
  const NotificationDto({
    this.read = false,
    this.id,
    this.type,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw FormatError<NotificationDto>();
    return NotificationDto(
      read: json['read'] as bool? ?? false,
      id: json['id'] as String?,
      type: json['type'] != null
          ? NotificationType.fromJson(json['type'] as String)
          : null,
      content: json['content'] != null
          ? NotificationContentDto.fromJson(json['content'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  final String? id;
  final NotificationType? type;
  final bool read;
  final NotificationContentDto? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type?.value,
    'read': read,
    'content': content,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

extension NotificationDtoToDomain on NotificationDto {
  Notification get toDomain {
    return Notification(
      id: id,
      type: type,
      read: read,
      content: content?.toDomain,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension NotificationToDto on Notification {
  NotificationDto get toDto {
    return NotificationDto(
      id: id,
      type: type,
      read: read,
      content: content?.toDto,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

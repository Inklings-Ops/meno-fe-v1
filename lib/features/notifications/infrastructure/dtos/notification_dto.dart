import 'package:meno/features/notifications/domain/domain.dart';
import 'package:meno/features/notifications/infrastructure/dtos/notification_content_dto.dart';

class NotificationDto {
  const NotificationDto({
    this.read = false,
    this.id,
    this.type,
    this.content,
    this.createdAt,
  });

  factory NotificationDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) throw Exception('Invalid type');
    return NotificationDto(
      id: json[_kId] as String?,
      type: json[_kType] != null
          ? NotificationType.fromJson(json[_kType])
          : null,
      read: (json[_kRead] as bool?) ?? false,
      content: json[_kContent] != null
          ? NotificationContentDto.fromJson(json[_kContent])
          : null,
      createdAt: json[_kCreatedAt] != null
          ? DateTime.parse(json[_kCreatedAt] as String)
          : null,
    );
  }

  final String? id;
  final NotificationType? type;
  final bool read;
  final NotificationContentDto? content;
  final DateTime? createdAt;

  static const String _kId = 'id';
  static const String _kType = 'type';
  static const String _kRead = 'read';
  static const String _kContent = 'content';
  static const String _kCreatedAt = 'createdAt';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kType: type?.toJson(),
    _kRead: read,
    _kContent: content?.toJson(),
    _kCreatedAt: createdAt,
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
    );
  }
}

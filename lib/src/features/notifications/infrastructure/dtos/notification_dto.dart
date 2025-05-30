import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

part 'notification_dto.g.dart';

@JsonSerializable()
class NotificationDto with EquatableMixin {
  const NotificationDto({
    this.read = false,
    this.id,
    this.type,
    this.content,
    this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  final String? id;
  final NotificationType? type;
  final bool read;
  final NotificationContentDto? content;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);

  @override
  List<Object?> get props => [id, type, read, content, createdAt];
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

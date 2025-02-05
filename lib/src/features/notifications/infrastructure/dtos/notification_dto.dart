import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification.dart';

import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_type.dart';
import 'package:meno_fe_v1/src/features/notifications/infrastructure/dtos/notification_content_dto.dart';

part 'notification_dto.freezed.dart';
part 'notification_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class NotificationDto with _$NotificationDto {
  const factory NotificationDto({
    String? id,
    NotificationType? type,
    @Default(false) bool read,
    NotificationContentDto? content,
    DateTime? createdAt,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);
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

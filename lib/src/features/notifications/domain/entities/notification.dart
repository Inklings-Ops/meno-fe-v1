import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_content.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_type.dart';

part 'notification.freezed.dart';

@freezed
class Notification with _$Notification {
  const factory Notification({
    String? id,
    NotificationType? type,
    @Default(false) bool read,
    NotificationContent? content,
    DateTime? createdAt,
  }) = _Notification;
}

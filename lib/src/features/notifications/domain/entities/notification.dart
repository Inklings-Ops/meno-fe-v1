import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_content.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_type.dart';

part 'notification.freezed.dart';

@freezed
class Notification with _$Notification {
  factory Notification({
    required String id,
    required NotificationType type,
    required bool read,
    required NotificationContent content,
    required DateTime createdAt,
  }) = _Notification;
}

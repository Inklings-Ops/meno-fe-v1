import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_content.dart';
import 'notification_type.dart';

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

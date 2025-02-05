import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification.dart';

part 'notification_data.freezed.dart';

@freezed
class NotificationData with _$NotificationData {
  const factory NotificationData({
    required List<Notification?> notifications,
    required int totalPages,
    required int currentPage,
    required int totalItems,
  }) = _NotificationData;
}

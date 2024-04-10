import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification.dart';

part 'notification_data.freezed.dart';

@freezed
class NotificationData with _$NotificationData {
  factory NotificationData({
    required List<Notification?> notifications,
    required int totalPages,
    required int currentPage,
    required int totalItems,
  }) = _NotificationData;
}

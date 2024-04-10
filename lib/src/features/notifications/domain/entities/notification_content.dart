import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_content.freezed.dart';

@freezed
class NotificationContent with _$NotificationContent {
  const factory NotificationContent({
    String? subscriberId,
    String? subscriberName,
    String? subscriptionId,
    String? subscriberImageUrl,
    String? cohostId,
    String? broadcastId,
    String? broadcastTitle,
    String? cohostFullName,
    String? cohostImageUrl,
    String? broadcastCreator,
    String? broadcastImageUrl,
    String? id,
    String? title,
    String? imageUrl,
  }) = _NotificationContent;
}

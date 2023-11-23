import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_content.freezed.dart';

@freezed
abstract class NotificationContent with _$NotificationContent {
  const factory NotificationContent.userSubscribed({
    required String subscriberId,
    required String subscriberName,
    required String subscriptionId,
    required String subscriberImageUrl,
  }) = UserSubscribed;

  const factory NotificationContent.addedAsCoHost({
    required String cohostId,
    required String broadcastId,
    required String broadcastTitle,
    required String cohostFullName,
    required String cohostImageUrl,
    required String broadcastCreator,
    required String broadcastImageUrl,
  }) = AddedAsCoHost;

  const factory NotificationContent.liveBroadcastStarted({
    required String id,
    required String title,
    required String imageUrl,
  }) = LiveBroadcastStarted;
}

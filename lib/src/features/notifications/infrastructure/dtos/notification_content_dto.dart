import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_content_dto.freezed.dart';
part 'notification_content_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
sealed class NotificationContentDto with _$NotificationContentDto {
  const factory NotificationContentDto.userSubscribed({
    required String subscriberId,
    required String subscriberName,
    required String subscriptionId,
    required String subscriberImageUrl,
  }) = UserSubscribed;

  const factory NotificationContentDto.addedAsCoHost({
    required String cohostId,
    required String broadcastId,
    required String broadcastTitle,
    required String cohostFullName,
    required String cohostImageUrl,
    required String broadcastCreator,
    required String broadcastImageUrl,
  }) = AddedAsCoHost;

  const factory NotificationContentDto.liveBroadcastStarted({
    required String id,
    required String title,
    required String imageUrl,
  }) = LiveBroadcastStarted;

  factory NotificationContentDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationContentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationContentDtoToJson(this);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification_content.dart';

part 'notification_content_dto.freezed.dart';
part 'notification_content_dto.g.dart';

@freezed
@JsonSerializable(
  explicitToJson: true,
  createFactory: false,
  includeIfNull: false,
)
class NotificationContentDto with _$NotificationContentDto {
  const factory NotificationContentDto({
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
  }) = _NotificationContentDto;

  factory NotificationContentDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationContentDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationContentDtoToJson(this);
}

extension NotificationContentDtoToDomain on NotificationContentDto {
  NotificationContent get toDomain {
    return NotificationContent(
      subscriberId: subscriberId,
      subscriberName: subscriberName,
      subscriptionId: subscriptionId,
      subscriberImageUrl: subscriberImageUrl,
      cohostId: cohostId,
      broadcastId: broadcastId,
      broadcastTitle: broadcastTitle,
      cohostFullName: cohostFullName,
      cohostImageUrl: cohostImageUrl,
      broadcastCreator: broadcastCreator,
      broadcastImageUrl: broadcastImageUrl,
      id: id,
      title: title,
      imageUrl: imageUrl,
    );
  }
}

extension NotificationContentToDto on NotificationContent {
  NotificationContentDto get toDto {
    return NotificationContentDto(
      subscriberId: subscriberId,
      subscriberName: subscriberName,
      subscriptionId: subscriptionId,
      subscriberImageUrl: subscriberImageUrl,
      cohostId: cohostId,
      broadcastId: broadcastId,
      broadcastTitle: broadcastTitle,
      cohostFullName: cohostFullName,
      cohostImageUrl: cohostImageUrl,
      broadcastCreator: broadcastCreator,
      broadcastImageUrl: broadcastImageUrl,
      id: id,
      title: title,
      imageUrl: imageUrl,
    );
  }
}

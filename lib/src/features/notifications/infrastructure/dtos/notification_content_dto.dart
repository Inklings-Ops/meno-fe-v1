import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

part 'notification_content_dto.g.dart';

@JsonSerializable()
class NotificationContentDto with EquatableMixin {
  const NotificationContentDto({
    this.subscriberId,
    this.subscriberName,
    this.subscriptionId,
    this.subscriberImageUrl,
    this.cohostId,
    this.broadcastId,
    this.broadcastTitle,
    this.cohostFullName,
    this.cohostImageUrl,
    this.broadcastCreator,
    this.broadcastImageUrl,
    this.id,
    this.title,
    this.imageUrl,
  });

  factory NotificationContentDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationContentDtoFromJson(json);

  final String? subscriberId;
  final String? subscriberName;
  final String? subscriptionId;
  final String? subscriberImageUrl;
  final String? cohostId;
  final String? broadcastId;
  final String? broadcastTitle;
  final String? cohostFullName;
  final String? cohostImageUrl;
  final String? broadcastCreator;
  final String? broadcastImageUrl;
  final String? id;
  final String? title;
  final String? imageUrl;

  Map<String, dynamic> toJson() => _$NotificationContentDtoToJson(this);

  @override
  List<Object?> get props => [
        subscriberId,
        subscriberName,
        subscriptionId,
        subscriberImageUrl,
        cohostId,
        broadcastId,
        broadcastTitle,
        cohostFullName,
        cohostImageUrl,
        broadcastCreator,
        broadcastImageUrl,
        id,
        title,
        imageUrl,
      ];
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

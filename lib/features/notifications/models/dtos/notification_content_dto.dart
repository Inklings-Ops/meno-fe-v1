import 'package:meno/_core/_core.dart';
import 'package:meno/features/notifications/models/entities/notification_content.dart';

class NotificationContentDto {
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

  factory NotificationContentDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatError<NotificationContentDto>();
    }

    return NotificationContentDto(
      subscriberId: json['subscriberId'] as String?,
      subscriberName: json['subscriberName'] as String?,
      subscriptionId: json['subscriptionId'] as String?,
      subscriberImageUrl: json['subscriberImageUrl'] as String?,
      cohostId: json['cohostId'] as String?,
      broadcastId: json['broadcastId'] as String?,
      broadcastTitle: json['broadcastTitle'] as String?,
      cohostFullName: json['cohostFullName'] as String?,
      cohostImageUrl: json['cohostImageUrl'] as String?,
      broadcastCreator: json['broadcastCreator'] as String?,
      broadcastImageUrl: json['broadcastImageUrl'] as String?,
      id: json['id'] as String?,
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

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

  Map<String, dynamic> toJson() => {
    'subscriberId': subscriberId,
    'subscriberName': subscriberName,
    'subscriptionId': subscriptionId,
    'subscriberImageUrl': subscriberImageUrl,
    'cohostId': cohostId,
    'broadcastId': broadcastId,
    'broadcastTitle': broadcastTitle,
    'cohostFullName': cohostFullName,
    'cohostImageUrl': cohostImageUrl,
    'broadcastCreator': broadcastCreator,
    'broadcastImageUrl': broadcastImageUrl,
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
  };
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

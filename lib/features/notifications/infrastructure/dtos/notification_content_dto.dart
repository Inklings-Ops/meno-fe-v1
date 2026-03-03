import 'package:meno/features/notifications/domain/domain.dart';

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
    if (json is! Map<String, dynamic>) throw Exception('Invalid type');
    return NotificationContentDto(
      subscriberId: json[_kSubscriberId] as String?,
      subscriberName: json[_kSubscriberName] as String?,
      subscriptionId: json[_kSubscriptionId] as String?,
      subscriberImageUrl: json[_kSubscriberImageUrl] as String?,
      cohostId: json[_kCohostId] as String?,
      broadcastId: json[_kBroadcastId] as String?,
      broadcastTitle: json[_kBroadcastTitle] as String?,
      cohostFullName: json[_kCohostFullName] as String?,
      cohostImageUrl: json[_kCohostImageUrl] as String?,
      broadcastCreator: json[_kBroadcastCreator] as String?,
      broadcastImageUrl: json[_kBroadcastImageUrl] as String?,
      id: json[_kId] as String?,
      title: json[_kTitle] as String?,
      imageUrl: json[_kImageUrl] as String?,
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

  static const String _kSubscriberId = 'subscriberId';
  static const String _kSubscriberName = 'subscriberName';
  static const String _kSubscriptionId = 'subscriptionId';
  static const String _kSubscriberImageUrl = 'subscriberImageUrl';
  static const String _kCohostId = 'cohostId';
  static const String _kBroadcastId = 'broadcastId';
  static const String _kBroadcastTitle = 'broadcastTitle';
  static const String _kCohostFullName = 'cohostFullName';
  static const String _kCohostImageUrl = 'cohostImageUrl';
  static const String _kBroadcastCreator = 'broadcastCreator';
  static const String _kBroadcastImageUrl = 'broadcastImageUrl';
  static const String _kId = 'id';
  static const String _kTitle = 'title';
  static const String _kImageUrl = 'imageUrl';

  Map<String, dynamic> toJson() => {
    _kSubscriberId: subscriberId,
    _kSubscriberName: subscriberName,
    _kSubscriptionId: subscriptionId,
    _kSubscriberImageUrl: subscriberImageUrl,
    _kCohostId: cohostId,
    _kBroadcastId: broadcastId,
    _kBroadcastTitle: broadcastTitle,
    _kCohostFullName: cohostFullName,
    _kCohostImageUrl: cohostImageUrl,
    _kBroadcastCreator: broadcastCreator,
    _kBroadcastImageUrl: broadcastImageUrl,
    _kId: id,
    _kTitle: title,
    _kImageUrl: imageUrl,
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

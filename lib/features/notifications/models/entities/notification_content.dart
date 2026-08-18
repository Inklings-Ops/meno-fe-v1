import 'package:equatable/equatable.dart';

final class NotificationContent with EquatableMixin {
  const NotificationContent({
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

  NotificationContent copyWith({
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
  }) {
    return NotificationContent(
      subscriberId: subscriberId ?? this.subscriberId,
      subscriberName: subscriberName ?? this.subscriberName,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      subscriberImageUrl: subscriberImageUrl ?? this.subscriberImageUrl,
      cohostId: cohostId ?? this.cohostId,
      broadcastId: broadcastId ?? this.broadcastId,
      broadcastTitle: broadcastTitle ?? this.broadcastTitle,
      cohostFullName: cohostFullName ?? this.cohostFullName,
      cohostImageUrl: cohostImageUrl ?? this.cohostImageUrl,
      broadcastCreator: broadcastCreator ?? this.broadcastCreator,
      broadcastImageUrl: broadcastImageUrl ?? this.broadcastImageUrl,
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

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

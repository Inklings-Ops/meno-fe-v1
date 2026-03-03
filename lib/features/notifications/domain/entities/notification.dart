import 'package:equatable/equatable.dart';
import 'package:meno/features/notifications/domain/domain.dart';
import 'package:skeletonizer/skeletonizer.dart';

final class Notification with EquatableMixin {
  const Notification({
    this.read = false,
    this.id,
    this.type,
    this.content,
    this.createdAt,
  });

  final String? id;
  final NotificationType? type;
  final bool read;
  final NotificationContent? content;
  final DateTime? createdAt;

  Notification copyWith({
    String? id,
    NotificationType? type,
    bool? read,
    NotificationContent? content,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      read: read ?? this.read,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, type, read, content, createdAt];
}

final fakeNotification = Notification(
  id: 'id',
  createdAt: DateTime.now(),
  content: NotificationContent(
    broadcastCreator: BoneMock.fullName,
    broadcastId: 'broadcastId',
    broadcastTitle: BoneMock.title,
    cohostFullName: BoneMock.fullName,
    id: 'id',
    subscriberId: 'subscriberId',
    subscriberName: BoneMock.name,
    subscriptionId: 'subscriberId',
    title: BoneMock.title,
  ),
);

final fakeNotificationsList = List.filled(3, fakeNotification);

final fakeNotifications = {
  NotificationCategory.none: <Notification?>[],
  NotificationCategory.older: fakeNotificationsList,
  NotificationCategory.thisWeek: fakeNotificationsList,
  NotificationCategory.today: fakeNotificationsList,
};

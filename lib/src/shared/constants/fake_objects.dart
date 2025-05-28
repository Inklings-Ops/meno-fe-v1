import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/features.dart';

final fakeNotes = List.filled(
  3,
  Note(
    uid: ID.fromString('uniqueIdStr'),
    title: SingleLineString(BoneMock.title),
    content: MultiLineString(BoneMock.longParagraph),
    folder: Folder(
      id: ID.fromString('id'),
      title: SingleLineString(BoneMock.name),
    ),
    createdAt: DateTime.now(),
  ),
);

final fakeFolders = List.filled(
  3,
  Folder(id: ID.fromString('id'), title: SingleLineString(BoneMock.title)),
);

final fakeParticipant = Participant(
  id: ID.fromString('1'),
  fullName: SingleLineString(BoneMock.name),
);

final fakeParticipants = List.filled(3, fakeParticipant);

final fakeBroadcasts = List.filled(
  3,
  Broadcast(
    id: ID.fromString('uniqueIdStr'),
    title: SingleLineString(BoneMock.title),
    description: MultiLineString(BoneMock.longParagraph),
    creator: fakeParticipant,
    creatorId: ID.fromString(BoneMock.name),
    fullName: SingleLineString(BoneMock.fullName),
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(hours: 1)),
    createdAt: DateTime.now(),
    liveListeners: 100,
    totalListeners: 200,
  ),
);

final fakeProfile = Profile(
  id: ID.fromString('1'),
  fullName: SingleLineString(BoneMock.name),
  bio: MultiLineString(BoneMock.paragraph),
  stats: const UserStats(),
);

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

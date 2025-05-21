import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/features.dart';

final fakeNotes = List.filled(
  3,
  Note(
    uid: Uid.fromString('uniqueIdStr'),
    title: NoteTitle(BoneMock.title),
    content: NoteContent(BoneMock.longParagraph),
    folder: Folder(id: Uid.fromString('id'), title: FolderTitle(BoneMock.name)),
    createdAt: DateTime.now(),
  ),
);

final fakeFolders = List.filled(
  3,
  Folder(id: Uid.fromString('id'), title: FolderTitle(BoneMock.title)),
);

final fakeBroadcastParticipant = BroadcastParticipant(
  id: '1',
  fullName: BoneMock.name,
);

final fakeBroadcastParticipants = List.filled(3, fakeBroadcastParticipant);

final fakeBroadcasts = List.filled(
  3,
  Broadcast(
    id: Uid.fromString('uniqueIdStr'),
    title: SingleLineString(BoneMock.title),
    description: BroadcastDescription(BoneMock.longParagraph),
    creator: fakeBroadcastParticipant,
    creatorId:BoneMock.name,
    fullName: BoneMock.fullName,
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(hours: 1)),
    createdAt: DateTime.now(),
    liveListeners: 100,
    totalListeners: 200,
  ),
);

final fakeProfile = Profile(
  id: 'id',
  fullName: SingleLineString(BoneMock.name),
  bio: Bio(BoneMock.paragraph),
  stats: UserStats(broadcasts: 0, subscribers: 0, subscriptions: 0),
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
    subscriptionId: 'subsciberId',
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

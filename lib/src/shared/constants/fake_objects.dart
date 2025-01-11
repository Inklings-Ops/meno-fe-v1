import 'package:meno_fe_v1/meno.dart';
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
  ),
);

final fakeProfile = Profile(
  id: 'id',
  fullName: SingleLineString(BoneMock.name),
  bio: Bio(BoneMock.paragraph),
  stats: UserStats(broadcasts: 0, subscribers: 0, subscriptions: 0),
);
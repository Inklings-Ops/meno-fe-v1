import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:skeletonizer/skeletonizer.dart';

final fakeNotes = List.filled(
  3,
  Note(
    uid: Uid.fromString('uniqueIdStr'),
    title: NoteTitle(BoneMock.title),
    content: NoteContent(BoneMock.longParagraph),
    folder: Folder(id: 'id', title: FolderTitle(BoneMock.name)),
    createdAt: DateTime.now(),
  ),
);

final fakeFolders = List.filled(
  3,
  Folder(id: 'id', title: FolderTitle(BoneMock.title)),
);

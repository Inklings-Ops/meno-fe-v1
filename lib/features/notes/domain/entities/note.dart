import 'package:equatable/equatable.dart';
import 'package:meno/features/notes/domain/entities/entities.dart';
import 'package:meno/shared/domain/domain.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Note with EquatableMixin implements IEntity {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.pinned = false,
    this.folder,
    this.creator,
    this.createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.synced,
  });

  factory Note.fromNewId(Id noteId) {
    return Note(
      id: noteId,
      title: SingleLineString.empty,
      content: MultiLineString.empty,
    );
  }

  @override
  final Id id;
  final SingleLineString title;
  final MultiLineString content;
  final bool pinned;
  final NoteFolder? folder;
  final NoteCreator? creator;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;

  static const Note empty = Note(
    id: Id.empty,
    title: SingleLineString.empty,
    content: MultiLineString.empty,
    creator: NoteCreator.empty,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    pinned,
    folder,
    creator,
    createdAt,
    updatedAt,
    syncStatus,
  ];

  Note copyWith({
    Id? id,
    SingleLineString? title,
    MultiLineString? content,
    bool? pinned,
    NoteFolder? folder,
    NoteCreator? creator,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      pinned: pinned ?? this.pinned,
      folder: folder ?? this.folder,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  bool get isValid => id.isValid && title.isValid && content.isValid;
}

final fakeNotes = List.filled(
  3,
  Note(
    id: Id.fromString('uniqueIdStr'),
    title: SingleLineString(BoneMock.title),
    content: MultiLineString(BoneMock.longParagraph),
    folder: NoteFolder(
      id: Id.fromString('id'),
      title: SingleLineString(BoneMock.name),
    ),
    createdAt: DateTime.now(),
  ),
);

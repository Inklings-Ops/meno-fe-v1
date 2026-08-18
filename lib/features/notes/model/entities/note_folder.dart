import 'package:equatable/equatable.dart';
import 'package:meno/_core/value_objects/value_objects.dart';
import 'package:meno/_shared/model/_model.dart';
import 'package:meno/features/notes/model/entities/note.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoteFolder with EquatableMixin implements IEntity {
  const NoteFolder({
    required this.id,
    required this.title,
    this.numberOfNotes = 0,
    this.pinned = false,
    this.createdAt,
    this.updatedAt,
    this.notes = const <Note?>[],
    this.syncStatus = SyncStatus.synced,
  });

  factory NoteFolder.fromNewId(Id folderId) {
    return NoteFolder(id: folderId, title: SingleLineString.empty);
  }

  @override
  final Id id;

  final SingleLineString title;
  final int numberOfNotes;
  final bool pinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Note?> notes;
  final SyncStatus syncStatus;

  static const NoteFolder empty = NoteFolder(
    id: Id.empty,
    title: SingleLineString.empty,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    numberOfNotes,
    pinned,
    createdAt,
    updatedAt,
    notes,
    syncStatus,
  ];

  NoteFolder copyWith({
    Id? id,
    SingleLineString? title,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Note?>? notes,
    SyncStatus? syncStatus,
  }) {
    return NoteFolder(
      id: id ?? this.id,
      title: title ?? this.title,
      numberOfNotes: numberOfNotes ?? this.numberOfNotes,
      pinned: pinned ?? this.pinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  bool get isValid => id.isValid && title.isValid;
}

final fakeFolders = List.filled(
  3,
  NoteFolder(id: Id.fromString('id'), title: SingleLineString(BoneMock.title)),
);

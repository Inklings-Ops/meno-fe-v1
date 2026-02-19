import 'package:equatable/equatable.dart';
import 'package:meno/features/notes/domain/entities/note.dart';
import 'package:meno/shared/domain/domain.dart';

class NoteFolder with EquatableMixin implements IEntity {
  const NoteFolder({
    required this.id,
    required this.title,
    this.numberOfNotes = 0,
    this.pinned = false,
    this.createdAt,
    this.notes = const <Note?>[],
    this.syncStatus = SyncStatus.synced,
  });

  @override
  final Id id;

  final SingleLineString title;
  final int numberOfNotes;
  final bool pinned;
  final DateTime? createdAt;
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
    notes,
    syncStatus,
  ];

  NoteFolder copyWith({
    Id? id,
    SingleLineString? title,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
    List<Note?>? notes,
    SyncStatus? syncStatus,
  }) {
    return NoteFolder(
      id: id ?? this.id,
      title: title ?? this.title,
      numberOfNotes: numberOfNotes ?? this.numberOfNotes,
      pinned: pinned ?? this.pinned,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}

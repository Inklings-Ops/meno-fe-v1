import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

class Folder with EquatableMixin implements IEntity {
  const Folder({
    required this.id,
    required this.title,
    this.numberOfNotes,
    this.pinned,
    this.createdAt,
    this.notes = const <Note?>[],
  });

  @override
  final ID id;

  final SingleLineString title;
  final int? numberOfNotes;
  final bool? pinned;
  final DateTime? createdAt;
  final List<Note?> notes;

  static Folder empty = Folder(
    id: ID.fromString(''),
    title: SingleLineString(''),
  );

  @override
  List<Object?> get props => [
        id,
        title,
        numberOfNotes,
        pinned,
        createdAt,
        notes,
      ];

  Folder copyWith({
    ID? id,
    SingleLineString? title,
    int? numberOfNotes,
    bool? pinned,
    DateTime? createdAt,
    List<Note?>? notes,
  }) {
    return Folder(
      id: id ?? this.id,
      title: title ?? this.title,
      numberOfNotes: numberOfNotes ?? this.numberOfNotes,
      pinned: pinned ?? this.pinned,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}

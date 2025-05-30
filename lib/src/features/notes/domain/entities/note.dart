import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/folder.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note_creator.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

class Note with EquatableMixin implements IEntity {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.pinned,
    this.createdAt,
    this.updatedAt,
    this.folder,
    this.creator,
  });

  @override
  final ID id;

  final SingleLineString title;
  final MultiLineString content;
  final bool? pinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Folder? folder;
  final NoteCreator? creator;

  static Note empty = Note(
    id: ID.fromString(''),
    title: SingleLineString(''),
    content: MultiLineString(''),
    creator: NoteCreator.empty,
  );

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        pinned,
        createdAt,
        updatedAt,
        folder,
        creator,
      ];

  Note copyWith({
    ID? id,
    SingleLineString? title,
    MultiLineString? content,
    bool? pinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    Folder? folder,
    NoteCreator? creator,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      pinned: pinned ?? this.pinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      folder: folder ?? this.folder,
      creator: creator ?? this.creator,
    );
  }
}

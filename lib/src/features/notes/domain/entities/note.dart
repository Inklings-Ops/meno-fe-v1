import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/folder.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note_creator.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note implements IEntity {
  const factory Note({
    required ID uid,
    required SingleLineString title,
    required MultiLineString content,
    bool? pinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    Folder? folder,
    NoteCreator? creator,
  }) = _Note;

  factory Note.empty() {
    return Note(
      uid: ID.fromString(''),
      title: SingleLineString(''),
      content: MultiLineString(''),
      creator: NoteCreator.empty(),
    );
  }
}

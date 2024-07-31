import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/folder.dart';
import 'package:meno_fe_v1/src/features/notes/domain/entities/note_creator.dart';
import 'package:meno_fe_v1/src/features/notes/domain/value_objects/note_content.dart';
import 'package:meno_fe_v1/src/features/notes/domain/value_objects/note_title.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note implements IEntity {
  const factory Note({
    required Uid<Note> uid,
    required NoteTitle title,
    required NoteContent content,
    bool? pinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    Folder? folder,
    NoteCreator? creator,
  }) = _Note;

  factory Note.empty() {
    return Note(
      uid: Uid<Note>.fromString(''),
      title: NoteTitle(''),
      content: NoteContent(''),
      creator: NoteCreator.empty(),
    );
  }
}

extension NoteExtension on Note {
  Option<ValueFailure<dynamic>> get failureOption {
    return title.failureOrUnit
        .andThen(content.failureOrUnit)
        .fold(some, (_) => none());
  }
}

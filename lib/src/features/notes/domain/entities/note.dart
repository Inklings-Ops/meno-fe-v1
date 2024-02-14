import 'package:freezed_annotation/freezed_annotation.dart';

import '../inputs/i_note_content.dart';
import '../inputs/i_note_title.dart';
import 'folder.dart';
import 'note_creator.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note {
  factory Note({
    int? dbId,
    required String id,
    required INoteTitle title,
    required INoteContent content,
    required bool pinned,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Folder folder,
    required NoteCreator creator,
  }) = _Note;
}

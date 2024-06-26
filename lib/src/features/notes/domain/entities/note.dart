import 'package:freezed_annotation/freezed_annotation.dart';

import '../inputs/i_note_content.dart';
import '../inputs/i_note_title.dart';
import 'folder.dart';
import 'note_creator.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note {
  const factory Note({
    int? dbId,
    String? id,
    required INoteTitle title,
    required INoteContent content,
    bool? pinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    Folder? folder,
    NoteCreator? creator,
  }) = _Note;

  factory Note.empty() {
    return Note(
      title: INoteTitle(''),
      content: INoteContent(''),
      creator: NoteCreator.empty(),
    );
  }
}

part of 'notes_bloc.dart';

@freezed
class NotesEvent with _$NotesEvent {
  const factory NotesEvent.getNotes({
    String? keywords,
    String? noteId,
    bool? pinned,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
  }) = _GetNotes;
  const factory NotesEvent.addToFolder(Folder folder, Note note) = _AddToFolder;
  const factory NotesEvent.removeFromFolder(
    Folder folder,
    Note note,
  ) = _RemoveFromFolder;
  const factory NotesEvent.deleteNote(Note note) = _DeleteNote;

}

part of 'note_list_bloc.dart';

@freezed
class NoteListEvent with _$NoteListEvent {
  const factory NoteListEvent.getAllNotes() = _GetAllNotes;
  const factory NoteListEvent.updateNotesList(Note newNote) = _UpdateNotesList;
  const factory NoteListEvent.addToFolder(Folder folder, Note note) = _AddToFolder;
  const factory NoteListEvent.removeFromFolder(Folder folder, Note note) = _RemoveFromFolder;
  const factory NoteListEvent.deleteNote(Note note) = _DeleteNote;
}
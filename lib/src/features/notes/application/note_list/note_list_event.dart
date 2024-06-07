part of 'note_list_bloc.dart';

@freezed
class NoteListEvent with _$NoteListEvent {
  const factory NoteListEvent.getAllNotes() = _GetAllNotes;
  const factory NoteListEvent.updateNotesList(Note newNote) = _UpdateNotesList;
  const factory NoteListEvent.deleteNote(Note note) = _DeleteNote;
}
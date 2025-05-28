part of 'note_editor_bloc.dart';

@freezed
class NoteEditorEvent with _$NoteEditorEvent {
  const factory NoteEditorEvent.initialize(Note note) = InitializeNoteEditor;

  const factory NoteEditorEvent.titleChanged(
    SingleLineString title,
  ) = NoteTitleChanged;

  const factory NoteEditorEvent.contentChanged(
    MultiLineString content,
  ) = NoteContentChanged;

  const factory NoteEditorEvent.saveRequested() = NoteSaveRequested;

  const factory NoteEditorEvent.exited() = NoteEditorExited;
}

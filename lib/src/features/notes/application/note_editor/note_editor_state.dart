part of 'note_editor_bloc.dart';

@freezed
class NoteEditorState with _$NoteEditorState {
  const factory NoteEditorState.loaded(Note note) = NoteLoaded;
  const factory NoteEditorState.saving() = NoteSaveInProgress;
  const factory NoteEditorState.saved(Note note) = NoteSaved;
  const factory NoteEditorState.failure(
    NoteException exception,
  ) = NoteEditorFailure;
}

part of 'note_editor_bloc.dart';

enum NoteEditorStatus { initial, loading, saved, failure }

@freezed
class NoteEditorState with _$NoteEditorState {
  const factory NoteEditorState({
    required Note note,
    @Default(NoteEditorStatus.initial) NoteEditorStatus status,
    @Default(false) bool isEditing,
    NoteException? failure,
  }) = _NoteEditorState;
}

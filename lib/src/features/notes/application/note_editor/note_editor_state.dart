part of 'note_editor_bloc.dart';

sealed class NoteEditorState with EquatableMixin {
  const NoteEditorState();

  @override
  List<Object?> get props => [];
}

final class NoteEditorLoadSuccess extends NoteEditorState {
  const NoteEditorLoadSuccess(this.note);
  final Note note;

  @override
  List<Object?> get props => [note];
}

final class NoteEditorSaveSuccess extends NoteEditorState {
  const NoteEditorSaveSuccess(this.note);
  final Note note;

  @override
  List<Object?> get props => [note];
}

final class NoteEditorFailure extends NoteEditorState {
  const NoteEditorFailure(this.exception);
  final NoteException exception;

  @override
  List<Object?> get props => [exception];
}

final class NoteEditorSaveInProgress extends NoteEditorState {
  const NoteEditorSaveInProgress();
}

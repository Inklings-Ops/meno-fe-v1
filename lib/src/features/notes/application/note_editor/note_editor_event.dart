part of 'note_editor_bloc.dart';

sealed class NoteEditorEvent with EquatableMixin {
  const NoteEditorEvent();

  @override
  List<Object?> get props => [];
}

final class NoteEditorInitializeRequested extends NoteEditorEvent {
  const NoteEditorInitializeRequested(this.note);
  final Note note;

  @override
  List<Object?> get props => [note];
}

final class NoteEditorTitleChanged extends NoteEditorEvent {
  const NoteEditorTitleChanged(this.title);
  final SingleLineString title;

  @override
  List<Object?> get props => [title];
}

final class NoteEditorContentChanged extends NoteEditorEvent {
  const NoteEditorContentChanged(this.content);
  final MultiLineString content;

  @override
  List<Object?> get props => [content];
}

final class NoteEditorSaveRequested extends NoteEditorEvent {
  const NoteEditorSaveRequested();
}

final class NoteEditorExitRequested extends NoteEditorEvent {
  const NoteEditorExitRequested();
}

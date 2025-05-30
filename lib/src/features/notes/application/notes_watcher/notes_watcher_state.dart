part of 'notes_watcher_bloc.dart';

sealed class NotesWatcherState with EquatableMixin {
  const NotesWatcherState();

  @override
  List<Object?> get props => [];
}

final class NotesWatcherInitial extends NotesWatcherState {
  const NotesWatcherInitial();
}

final class NotesWatcherLoadInProgress extends NotesWatcherState {
  const NotesWatcherLoadInProgress();
}

final class NotesWatcherNoteCreated extends NotesWatcherState {
  const NotesWatcherNoteCreated(this.note);
  final Note note;

  @override
  List<Object?> get props => [note];
}

final class NotesWatcherNoteDeleted extends NotesWatcherState {
  const NotesWatcherNoteDeleted(this.note);
  final Note note;

  @override
  List<Object?> get props => [note];
}

final class NotesWatcherNoteAddedToFolder extends NotesWatcherState {
  const NotesWatcherNoteAddedToFolder(this.note, this.folder);
  final Note note;
  final Folder folder;

  @override
  List<Object?> get props => [note, folder];
}

final class NotesWatcherNoteRemovedFromFolder extends NotesWatcherState {
  const NotesWatcherNoteRemovedFromFolder(this.note, this.folder);
  final Note note;
  final Folder folder;

  @override
  List<Object?> get props => [note, folder];
}

final class NotesWatcherFolderDeleted extends NotesWatcherState {
  const NotesWatcherFolderDeleted(this.folder);
  final Folder folder;

  @override
  List<Object?> get props => [folder];
}

final class NotesWatcherLoadFailed extends NotesWatcherState {
  const NotesWatcherLoadFailed(this.exception);
  final NoteException exception;

  @override
  List<Object?> get props => [exception];
}

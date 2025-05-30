part of 'notes_watcher_bloc.dart';

sealed class NotesWatcherEvent with EquatableMixin {
  const NotesWatcherEvent();

  @override
  List<Object?> get props => [];
}

final class NotesWatcherDeleteNoteRequested extends NotesWatcherEvent {
  const NotesWatcherDeleteNoteRequested(this.note);
  final Note note;

  @override
  List<Object?> get props => [note];
}

final class NotesWatcherDeleteFolderRequested extends NotesWatcherEvent {
  const NotesWatcherDeleteFolderRequested(this.folder);
  final Folder folder;

  @override
  List<Object?> get props => [folder];
}

final class NotesWatcherAddNoteToFolderRequested extends NotesWatcherEvent {
  const NotesWatcherAddNoteToFolderRequested(this.note, this.folder);
  final Note note;
  final Folder folder;

  @override
  List<Object?> get props => [note, folder];
}

final class NotesWatcherRemoveNoteToFolderRequested extends NotesWatcherEvent {
  const NotesWatcherRemoveNoteToFolderRequested(this.note, this.folder);
  final Note note;
  final Folder folder;

  @override
  List<Object?> get props => [note, folder];
}

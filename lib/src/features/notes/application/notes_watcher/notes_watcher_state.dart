part of 'notes_watcher_bloc.dart';

@freezed
class NotesWatcherState with _$NotesWatcherState {
  const factory NotesWatcherState.initial() = NoteWatcherInitial;

  const factory NotesWatcherState.loading() = NoteWatcherLoading;

  const factory NotesWatcherState.noteCreated(Note note) = NoteCreated;

  const factory NotesWatcherState.noteDeleted(Note note) = NoteDeleted;

  const factory NotesWatcherState.folderDeleted(Folder folder) = FolderDeleted;

  const factory NotesWatcherState.noteAddedToFolder({
    required Note note,
    required Folder folder,
  }) = NoteAddedToFolder;

  const factory NotesWatcherState.noteRemovedFromFolder({
    required Note note,
    required Folder folder,
  }) = NoteRemovedFromFolder;

  const factory NotesWatcherState.failure(
    NoteException exception,
  ) = NoteWatcherFailed;
}

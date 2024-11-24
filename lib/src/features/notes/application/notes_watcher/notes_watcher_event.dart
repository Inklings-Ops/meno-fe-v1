part of 'notes_watcher_bloc.dart';

@freezed
class NotesWatcherEvent with _$NotesWatcherEvent {
  const factory NotesWatcherEvent.deleteNote(Note note) = DeleteNote;
  const factory NotesWatcherEvent.addNoteToFolder(
    Note note,
    Folder folder,
  ) = AddNoteToFolder;
  const factory NotesWatcherEvent.removeNoteFromFolder(
    Note note,
    Folder folder,
  ) = RemoveNoteFromFolder;
}

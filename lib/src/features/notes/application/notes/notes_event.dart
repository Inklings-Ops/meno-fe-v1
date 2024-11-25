part of 'notes_bloc.dart';

@freezed
class NotesEvent with _$NotesEvent {
  const factory NotesEvent.getNotesRequested({
    String? keywords,
    Uid<Note>? noteId,
    bool? pinned,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
  }) = GetNotesRequested;

  const factory NotesEvent.reload() = ReloadNotes;

  const factory NotesEvent.noteReceived(Note note) = NoteReceived;

  const factory NotesEvent.noteRemoved(Note note) = NoteRemoved;
}

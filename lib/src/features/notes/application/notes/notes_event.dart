part of 'notes_bloc.dart';

@freezed
class NotesEvent with _$NotesEvent {
  const factory NotesEvent.getNotesRequested({
    String? keywords,
    String? noteId,
    bool? pinned,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
  }) = GetNotesRequested;

  const factory NotesEvent.reload() = ReloadNotes;

  const factory NotesEvent.deleteNoteRequested(
    Uid<Note> noteId,
  ) = DeleteNoteRequested;
}

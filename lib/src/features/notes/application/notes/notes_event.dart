// notes_event.dart
part of 'notes_bloc.dart';

@freezed
class NotesEvent with _$NotesEvent {
  // Event to fetch/refresh notes, potentially with search terms
  const factory NotesEvent.getNotesRequested({
    String? keywords,
    Uid<Note>? noteId,
    @Default('createdAt') String sortBy,
    @Default('DESC') String orderBy,
    @Default(false) bool pinned,
    @Default(1) int page , 
    @Default(1) int size, 
  }) = GetNotesRequested;

  // Event specifically for triggering pagination
  const factory NotesEvent.fetchMoreNotes({
    String? keywords,
    Uid<Note>? noteId,
    @Default('createdAt') String sortBy,
    @Default('DESC') String orderBy,
    @Default(false) bool pinned,
    @Default(1) int page, 
    @Default(1) int size, 
  }) = FetchMoreNotes;

  // Event triggered by the search input
  const factory NotesEvent.searchChanged(String keywords) = SearchChanged;

  // Event to reload the first page, clearing search
  const factory NotesEvent.reload() = ReloadNotes;

  // Events for real-time updates (no change needed here)
  const factory NotesEvent.noteReceived(Note note) = NoteReceived;
  const factory NotesEvent.noteRemoved(Note note) = NoteRemoved;
}

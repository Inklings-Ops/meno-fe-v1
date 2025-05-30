part of 'notes_bloc.dart';

sealed class NotesEvent with EquatableMixin {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

final class NotesFetchNotesRequested extends NotesEvent {
  const NotesFetchNotesRequested({
    this.keywords,
    this.noteId,
    this.sortBy = 'createdAt',
    this.orderBy = 'DESC',
    this.pinned = false,
    this.page = 1,
    this.size = 6,
  });

  final String? keywords;
  final ID? noteId;
  final String sortBy;
  final String orderBy;
  final bool pinned;
  final int page;
  final int size;

  @override
  List<Object?> get props => [
        keywords,
        noteId,
        sortBy,
        orderBy,
        pinned,
        page,
        size,
      ];
}

final class NotesFetchMoreNotesRequested extends NotesEvent {
  const NotesFetchMoreNotesRequested({
    this.keywords,
    this.noteId,
    this.sortBy = 'createdAt',
    this.orderBy = 'DESC',
    this.pinned = false,
    this.page = 1,
    this.size = 6,
  });

  final String? keywords;
  final ID? noteId;
  final String sortBy;
  final String orderBy;
  final bool pinned;
  final int page;
  final int size;

  @override
  List<Object?> get props => [
        keywords,
        noteId,
        sortBy,
        orderBy,
        pinned,
        page,
        size,
      ];
}

final class NotesSearchKeywordChanged extends NotesEvent {
  const NotesSearchKeywordChanged(this.keywords);
  final String keywords;

  @override
  List<Object?> get props => [keywords];
}

final class NotesReloadNotesRequested extends NotesEvent {
  const NotesReloadNotesRequested();
}

final class NotesNoteReceived extends NotesEvent {
  const NotesNoteReceived(this.note);
  final Note note;

  @override
  List<Object?> get props => [note];
}

final class NotesNoteRemoved extends NotesEvent {
  const NotesNoteRemoved(this.note);
  final Note note;

  @override
  List<Object?> get props => [note];
}

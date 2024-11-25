import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

part 'notes_bloc.freezed.dart';
part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({
    required INoteFacade facade,
  })  : _facade = facade,
        super(const NotesInitial()) {
    on<GetNotesRequested>(_onGetNotes);
    on<ReloadNotes>(_onReload);
    on<NoteReceived>(_onNoteReceived);
    on<NoteRemoved>(_onNoteRemoved);

    add(const GetNotesRequested());
  }

  final INoteFacade _facade;

  Future<void> _onGetNotes(
    GetNotesRequested event,
    Emitter<NotesState> emit,
  ) async {
    emit(const NotesLoadInProgress());
    final failureOrNotes = await _facade.getAllNotes(
      keywords: event.keywords,
      noteId: event.noteId,
      pinned: event.pinned,
      sortBy: event.sortBy,
      orderBy: event.orderBy,
      page: event.page,
      size: event.size,
    );
    emit(failureOrNotes.fold(NotesFailure.new, NotesLoadSuccess.new));
  }

  Future<void> _onReload(ReloadNotes event, Emitter<NotesState> emit) async {
    final failureOrNotes = await _facade.getAllNotes();
    emit(failureOrNotes.fold(NotesFailure.new, NotesLoadSuccess.new));
  }

  void _onNoteRemoved(NoteRemoved event, Emitter<NotesState> emit) {
    if (state is! NotesLoadSuccess) return;

    final noteId = event.note.uid;
    final oldNotes = List<Note?>.from((state as NotesLoadSuccess).notes);
    final newNotes = oldNotes.where((e) => e!.uid != noteId).toList();
    return emit(NotesLoadSuccess(newNotes));
  }

  void _onNoteReceived(NoteReceived event, Emitter<NotesState> emit) {
    if (state is! NotesLoadSuccess) return;
    final oldNotes = List<Note?>.from((state as NotesLoadSuccess).notes);
    final index = oldNotes.indexWhere((n) => n?.uid == event.note.uid);
    if (index == -1) {
      oldNotes.insert(0, event.note);
    } else {
      oldNotes[index] = event.note;
    }
    emit(NotesLoadSuccess(oldNotes));
  }
}

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
    on<DeleteNoteRequested>(_onDeleteNote);
    on<ReloadNotes>(_onReload);

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

  Future<void> _onDeleteNote(
    DeleteNoteRequested event,
    Emitter<NotesState> emit,
  ) async {
    if (state is! NotesLoadSuccess) return;

    final noteId = event.noteId;
    final oldNotes = List<Note?>.from((state as NotesLoadSuccess).notes);
    final newNotes = oldNotes.where((e) => e!.uid != noteId).toList();
    emit(NotesLoadSuccess(newNotes));

    final failureOrNotes = await _facade.deleteNote(noteId);
    failureOrNotes.fold((failure) => emit(NotesFailure(failure)), (_) => null);
  }
}

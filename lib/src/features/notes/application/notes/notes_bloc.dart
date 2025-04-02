import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:rxdart/rxdart.dart';

part 'notes_bloc.freezed.dart';
part 'notes_event.dart';
part 'notes_state.dart';

const int _defaultPageSize = 6;

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({
    required INoteFacade facade,
  })  : _facade = facade,
        super(const NotesState()) {
    on<GetNotesRequested>(_onGetNotes, transformer: _debounceAndSwitch());
    on<FetchMoreNotes>(_onFetchMoreNotes, transformer: _throttleDroppable());
    on<SearchChanged>(_onSearchChanged);
    on<ReloadNotes>(_onReload);
    on<NoteReceived>(_onNoteReceived);
    on<NoteRemoved>(_onNoteRemoved);

    add(const GetNotesRequested());
  }

  final INoteFacade _facade;

  EventTransformer<GetNotesRequested> _debounceAndSwitch<GetNotesRequested>() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap(mapper);
  }

  EventTransformer<FetchMoreNotes> _throttleDroppable<FetchMoreNotes>() {
    return (events, mapper) => events
        .throttleTime(
          const Duration(milliseconds: 300),
          leading: true,
          trailing: false,
        )
        .switchMap(mapper);
  }

  Future<void> _onGetNotes(
    GetNotesRequested event,
    Emitter<NotesState> emit,
  ) async {
    final pageToFetch = event.page;
    final keywords = event.keywords;

    emit(
      state.copyWith(
        status: NotesStatus.loading,
        currentKeywords: keywords,
      ),
    );

    final failureOrNotes = await _facade.getAllNotes(
      keywords: event.keywords,
      noteId: event.noteId,
      pinned: event.pinned,
      sortBy: event.sortBy,
      orderBy: event.orderBy,
      page: pageToFetch,
      size: state.pageSize,
    );

    emit(
      failureOrNotes.fold(
        (failure) => state.copyWith(
          status: NotesStatus.failure,
          failure: failure,
        ),
        (notes) => state.copyWith(
          status: NotesStatus.loadSuccess,
          notes: notes,
          currentPage: pageToFetch,
          hasReachedMax: notes.length < state.pageSize,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onFetchMoreNotes(
    FetchMoreNotes event,
    Emitter<NotesState> emit,
  ) async {
    if (state.hasReachedMax || state.status == NotesStatus.loadingMore) return;

    emit(state.copyWith(status: NotesStatus.loadingMore));

    final nextPage = state.currentPage + 1;

    final failureOrNotes = await _facade.getAllNotes(
      keywords: state.currentKeywords,
      noteId: event.noteId,
      pinned: event.pinned,
      sortBy: event.sortBy,
      orderBy: event.orderBy,
      page: nextPage,
      size: state.pageSize,
    );

    emit(
      failureOrNotes.fold(
        (failure) => state.copyWith(
          status: NotesStatus.failure,
          failure: failure,
        ),
        (newNotes) => state.copyWith(
          status: NotesStatus.loadSuccess,
          notes: List.of(state.notes)..addAll(newNotes),
          currentPage: nextPage,
          hasReachedMax: newNotes.length < state.pageSize,
          failure: null,
        ),
      ),
    );
  }

  void _onSearchChanged(SearchChanged event, Emitter<NotesState> emit) {
    add(
      GetNotesRequested(
        keywords: event.keywords.isEmpty ? null : event.keywords,
        size: state.pageSize,
      ),
    );
  }

  Future<void> _onReload(ReloadNotes event, Emitter<NotesState> emit) async {
    emit(
      state.copyWith(
        status: NotesStatus.loading,
        currentKeywords: null,
      ),
    );

    final failureOrNotes = await _facade.getAllNotes(
      page: 1,
      size: state.pageSize,
    );

    emit(
      failureOrNotes.fold(
        (failure) => state.copyWith(
          status: NotesStatus.failure,
          failure: failure,
        ),
        (notes) => state.copyWith(
          status: NotesStatus.loadSuccess,
          notes: notes,
          currentPage: 1,
          hasReachedMax: notes.length < state.pageSize,
          failure: null,
        ),
      ),
    );
  }

  void _onNoteRemoved(NoteRemoved event, Emitter<NotesState> emit) {
    final noteId = event.note.uid;
    final updatedNotes = state.notes.where((e) => e?.uid != noteId).toList();
    emit(state.copyWith(notes: updatedNotes));
  }

  void _onNoteReceived(NoteReceived event, Emitter<NotesState> emit) {
    final updatedNotes = List<Note?>.from(state.notes);
    final index = updatedNotes.indexWhere((n) => n?.uid == event.note.uid);

    if (index == -1) {
      updatedNotes.insert(0, event.note);
    } else {
      updatedNotes[index] = event.note;
    }
    emit(state.copyWith(notes: updatedNotes));
  }
}

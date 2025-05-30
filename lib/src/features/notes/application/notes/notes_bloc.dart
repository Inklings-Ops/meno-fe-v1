// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:rxdart/rxdart.dart';

part 'notes_event.dart';
part 'notes_state.dart';

const int _defaultPageSize = 6;

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({
    required INoteFacade facade,
  })  : _facade = facade,
        super(const NotesState()) {
    on<NotesFetchNotesRequested>(
      _onGetNotes,
      transformer: _debounceAndSwitch(),
    );
    on<NotesFetchMoreNotesRequested>(
      _onFetchMoreNotes,
      transformer: _throttleDroppable(),
    );
    on<NotesSearchKeywordChanged>(_onSearchChanged);
    on<NotesReloadNotesRequested>(_onReload);
    on<NotesNoteReceived>(_onNoteReceived);
    on<NotesNoteRemoved>(_onNoteRemoved);

    add(const NotesFetchNotesRequested());
  }

  final INoteFacade _facade;

  EventTransformer<NotesFetchNotesRequested>
      _debounceAndSwitch<NotesFetchNotesRequested>() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap(mapper);
  }

  EventTransformer<NotesFetchMoreNotesRequested>
      _throttleDroppable<NotesFetchMoreNotesRequested>() {
    return (events, mapper) => events
        .throttleTime(
          const Duration(milliseconds: 300),
          leading: true,
          trailing: false,
        )
        .switchMap(mapper);
  }

  Future<void> _onGetNotes(
    NotesFetchNotesRequested event,
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
        (paginatedList) => state.copyWith(
          status: NotesStatus.loadSuccess,
          notes: paginatedList.items,
          currentPage: pageToFetch,
          hasReachedMax: paginatedList.items.length < state.pageSize,
        ),
      ),
    );
  }

  Future<void> _onFetchMoreNotes(
    NotesFetchMoreNotesRequested event,
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
        (paginatedList) => state.copyWith(
          status: NotesStatus.loadSuccess,
          notes: List.of(state.notes)..addAll(paginatedList.items),
          currentPage: nextPage,
          hasReachedMax: paginatedList.items.length < state.pageSize,
        ),
      ),
    );
  }

  void _onSearchChanged(
    NotesSearchKeywordChanged event,
    Emitter<NotesState> emit,
  ) {
    add(
      NotesFetchNotesRequested(
        keywords: event.keywords.isEmpty ? null : event.keywords,
        size: state.pageSize,
      ),
    );
  }

  Future<void> _onReload(
    NotesReloadNotesRequested event,
    Emitter<NotesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotesStatus.loading,
        currentKeywords: null,
      ),
    );

    final fOrNotes = await _facade.getAllNotes(page: 1, size: state.pageSize);

    emit(
      fOrNotes.fold(
        (failure) => state.copyWith(
          status: NotesStatus.failure,
          failure: failure,
        ),
        (paginatedList) => state.copyWith(
          status: NotesStatus.loadSuccess,
          notes: paginatedList.items,
          currentPage: 1,
          hasReachedMax: paginatedList.items.length < state.pageSize,
          failure: null,
        ),
      ),
    );
  }

  void _onNoteRemoved(NotesNoteRemoved event, Emitter<NotesState> emit) {
    final noteId = event.note.id;
    final updatedNotes = state.notes.where((e) => e?.id != noteId).toList();
    emit(state.copyWith(notes: updatedNotes));
  }

  void _onNoteReceived(NotesNoteReceived event, Emitter<NotesState> emit) {
    final updatedNotes = List<Note?>.from(state.notes);
    final index = updatedNotes.indexWhere((n) => n?.id == event.note.id);

    if (index == -1) {
      updatedNotes.insert(0, event.note);
    } else {
      updatedNotes[index] = event.note;
    }
    emit(state.copyWith(notes: updatedNotes));
  }
}

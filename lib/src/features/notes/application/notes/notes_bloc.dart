import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';


part 'notes_bloc.freezed.dart';
part 'notes_event.dart';
part 'notes_state.dart';

@lazySingleton
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final INoteFacade _facade;
  StreamSubscription<Either<NoteException, List<Note?>>>? _noteSub;
  NotesBloc({required INoteFacade facade})
      : _facade = facade,
        super(NotesState.initial()) {
    on<_GetNotes>(_onGetNotes);
    on<_DeleteNote>(_onDeleteNote);
    on<_AddToFolder>(_onAddToFolder);
    on<_RemoveFromFolder>(_onRemoveFromFolder);
  }
  void init() => add(const NotesEvent.getNotes());
  bool get hasNotes => state.notes.isNotEmpty;

  Future<void> _onRemoveFromFolder(
    _RemoveFromFolder event,
    Emitter<NotesState> emit,
  ) async {
    final notes = [...state.notes];

    emit(state.copyWith(isLoading: true));

    final result = await _facade.removeNoteFromFolder(
      noteId: event.note.uid.getOr(),
      folderId: event.folder.id,
    );

    return result.fold(
      (failure) => emit(state.copyWith(exception: failure, isLoading: false)),
      (_) {
        final index = notes.indexWhere((note) => note?.uid == note!.uid);
        if (index != -1) {
          notes[index] = event.note.copyWith(folder: null);
          emit(state.copyWith(notes: notes, isLoading: false));
        }
      },
    );
  }

  Future<void> _onAddToFolder(
    _AddToFolder event,
    Emitter<NotesState> emit,
  ) async {
    final notes = [...state.notes];

    emit(state.copyWith(isLoading: true));

    final result = await _facade.addNoteToFolder(
      noteId: event.note.uid.getOr(),
      folderId: event.folder.id,
    );

    return result.fold(
      (failure) => emit(state.copyWith(exception: failure, isLoading: false)),
      (note) {
        final index = notes.indexWhere((note) => note?.uid == note!.uid);
        if (index != -1) {
          notes[index] = note;
          emit(state.copyWith(notes: notes, isLoading: false));
        }
      },
    );
  }

  Future<void> _onGetNotes(_GetNotes event, Emitter<NotesState> emit) async {
    emit(state.copyWith(isLoading: true));
    final fOrN = await _facade.getAllNotes(
      keywords: event.keywords,
      noteId: event.noteId,
      pinned: event.pinned,
      sortBy: event.sortBy,
      orderBy: event.orderBy,
      page: event.page,
      size: event.size,
    );
    emit(fOrN.fold(
      (f) => state.copyWith(exception: f, isLoading: false),
      (t) => state.copyWith(notes: t, isLoading: false),
    ));
  }

  Future<void> _onDeleteNote(
    _DeleteNote event,
    Emitter<NotesState> emit,
  ) async {
    final notes = [...state.notes];
    emit(state.copyWith(isLoading: true));
    final result = await _facade.deleteNote(event.note);
    return result.fold(
      (failure) => emit(state.copyWith(exception: failure, isLoading: false)),
      (_) {
        final updatedNotes =
            notes.where((n) => n?.uid != event.note.uid).toList();
        emit(state.copyWith(notes: updatedNotes, isLoading: false));
      },
    );
  }

  @override
  Future<void> close() async {
    await _noteSub?.cancel();
    return super.close();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/notes/domain/exceptions/note_exception.dart';

import '../../domain/domain.dart';

part 'note_list_bloc.freezed.dart';
part 'note_list_event.dart';
part 'note_list_state.dart';

@lazySingleton
class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  final INoteFacade _facade;
  NoteListBloc({required INoteFacade facade})
      : _facade = facade,
        super(const NoteListState.success([])) {
    on<_GetAllNotes>(_onGetAllNotes);
    on<_UpdateNotesList>(_onUpdateNotesList);
    on<_DeleteNote>(_onDeleteNote);
    on<_AddToFolder>(_onAddToFolder);
    on<_RemoveFromFolder>(_onRemoveFromFolder);
  }

  bool get hasNotes {
    if (state is _Success) {
      return (state as _Success).notes.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<void> _onRemoveFromFolder(
    _RemoveFromFolder event,
    Emitter<NoteListState> emit,
  ) async {
    final notes = [...(state as _Success).notes];

    emit(const _Loading());

    final result = await _facade.removeNoteFromFolder(
      noteId: event.note.id!,
      folderId: event.folder.id,
    );

    return result.fold(
      (failure) => emit(_Failure(failure)),
      (_) {
        final index = notes.indexWhere((note) => note?.id == note!.id);
        if (index != -1) {
          notes[index] = event.note.copyWith(folder: null);
          emit(_Success(notes));
        }
      },
    );
  }

  Future<void> _onAddToFolder(
    _AddToFolder event,
    Emitter<NoteListState> emit,
  ) async {
    final notes = [...(state as _Success).notes];

    emit(const _Loading());

    final result = await _facade.addNoteToFolder(
      noteId: event.note.id!,
      folderId: event.folder.id,
    );

    return result.fold(
      (failure) => emit(_Failure(failure)),
      (note) {
        final index = notes.indexWhere((note) => note?.id == note!.id);
        if (index != -1) {
          notes[index] = note;
          emit(_Success(notes));
        }
      },
    );
  }

  Future<void> _onUpdateNotesList(
    _UpdateNotesList event,
    Emitter<NoteListState> emit,
  ) async {
    if (state is _Success) {
      final currentState = state as _Success;
      final notes = [...currentState.notes];

      if (notes.isEmpty) {
        add(const _GetAllNotes());
        return;
      }

      final index = notes.indexWhere((note) => note?.id == event.newNote.id);
      if (index != -1) {
        notes[index] = event.newNote;
        emit(_Success(notes));
      } 
      // else {
      //   emit(_Success([event.newNote, ...notes]));
      // }
    }
  }

  Future<void> _onGetAllNotes(
    _GetAllNotes event,
    Emitter<NoteListState> emit,
  ) async {
    emit(const _Loading());

    final result = await _facade.getAllNotes();

    return result.fold(
      (failure) => emit(_Failure(failure)),
      (notes) => emit(_Success(notes)),
    );
  }

  Future<void> _onDeleteNote(
    _DeleteNote event,
    Emitter<NoteListState> emit,
  ) async {
    final notes = [...(state as _Success).notes];

    emit(const _Loading());

    final result = await _facade.deleteNote(event.note.id!);

    return result.fold(
      (failure) => emit(_Failure(failure)),
      (_) {
        notes.removeWhere((note) => note?.id == event.note.id);
        emit(_Success(notes));
      },
    );
  }
}

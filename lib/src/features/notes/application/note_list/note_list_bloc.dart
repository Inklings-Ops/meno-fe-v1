import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

part 'note_list_bloc.freezed.dart';
part 'note_list_event.dart';
part 'note_list_state.dart';

@lazySingleton
class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  final INoteFacade _facade;
  NoteListBloc({required INoteFacade facade})
      : _facade = facade,
        super(const NoteListState.empty()) {
    on<_GetAllNotes>(_onGetAllNotes);
    on<_UpdateNotesList>(_onUpdateNotesList);
    on<_DeleteNote>(_onDeleteNote);
  }

  bool get hasNotes {
    if (state is _Success) {
      return (state as _Success).notes.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<void> _onUpdateNotesList(
    _UpdateNotesList event,
    Emitter<NoteListState> emit,
  ) async {
    if (state is _Success) {
      final currentState = state as _Success;
      final notes = currentState.notes;
      final index = notes.indexWhere((note) => note?.id == event.newNote.id);
      if (index != -1) {
        final updatedNotes = [...notes];
        updatedNotes[index] = event.newNote;
        emit(_Success(updatedNotes));
      }
    }
  }

  Future<void> _onGetAllNotes(
    _GetAllNotes event,
    Emitter<NoteListState> emit,
  ) async {
    emit(const _Loading());

    final result = await _facade.getAllNotes();

    return result.fold(
      (failure) => emit(const _Failure()),
      (notes) => notes.isEmpty ? emit(const _Empty()) : emit(_Success(notes)),
    );
  }

  Future<void> _onDeleteNote(
    _DeleteNote event,
    Emitter<NoteListState> emit,
  ) async {
    final result = await _facade.deleteNote(event.note.id!);

    return result.fold(
      (failure) => emit(const _Failure()),
      (_) {
        if (state is _Success) {
          final notes = (state as _Success).notes;
          final updatedNotes =
              notes.where((note) => note?.id != event.note.id).toList();
          emit(_Success(updatedNotes));
        }
      },
    );
  }
}

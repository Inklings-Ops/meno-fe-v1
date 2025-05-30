import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

part 'note_editor_event.dart';
part 'note_editor_state.dart';

class NoteEditorBloc extends Bloc<NoteEditorEvent, NoteEditorState> {
  NoteEditorBloc({required INoteFacade facade})
      : _facade = facade,
        super(NoteEditorLoadSuccess(Note.empty)) {
    on<NoteEditorInitializeRequested>(_onInit);
    on<NoteEditorTitleChanged>(_onTitleChanged);
    on<NoteEditorContentChanged>(_onContentChanged);
    on<NoteEditorSaveRequested>(_onNoteSaveRequested);
    on<NoteEditorExitRequested>(_onExited);
  }

  final INoteFacade _facade;

  bool get isNoteEmpty {
    return switch (state) {
      NoteEditorLoadSuccess(:final note) =>
        !(note.title.isValid && note.content.isValid),
      _ => false
    };
  }

  bool get isDoneEditingAndValid {
    return switch (state) {
      NoteEditorLoadSuccess(:final note) =>
        note.id.isValid && note.title.isValid,
      _ => false
    };
  }

  void _onInit(
    NoteEditorInitializeRequested event,
    Emitter<NoteEditorState> emit,
  ) {
    return emit(NoteEditorLoadSuccess(event.note));
  }

  void _onTitleChanged(
    NoteEditorTitleChanged event,
    Emitter<NoteEditorState> emit,
  ) {
    if (state is! NoteEditorLoadSuccess) return;
    final note =
        (state as NoteEditorLoadSuccess).note.copyWith(title: event.title);
    return emit(NoteEditorLoadSuccess(note));
  }

  void _onContentChanged(
    NoteEditorContentChanged event,
    Emitter<NoteEditorState> emit,
  ) {
    if (state is! NoteEditorLoadSuccess) return;
    final note = (state as NoteEditorLoadSuccess).note.copyWith(
          content: event.content,
        );
    return emit(NoteEditorLoadSuccess(note));
  }

  Future<void> _onNoteSaveRequested(
    NoteEditorSaveRequested event,
    Emitter<NoteEditorState> emit,
  ) async {
    if (state is NoteEditorSaveInProgress) return;

    if (state is NoteEditorLoadSuccess) {
      final note = (state as NoteEditorLoadSuccess).note;

      emit(const NoteEditorSaveInProgress());

      if (note.title.isValid) {
        final failureOrNote = note.id.isValid
            ? await _facade.updateNote(note: note)
            : await _facade.createNote(note);

        emit(
          failureOrNote.fold(
            NoteEditorFailure.new,
            NoteEditorSaveSuccess.new,
          ),
        );
      }
    }
  }

  void _onExited(
    NoteEditorExitRequested event,
    Emitter<NoteEditorState> emit,
  ) {}
}

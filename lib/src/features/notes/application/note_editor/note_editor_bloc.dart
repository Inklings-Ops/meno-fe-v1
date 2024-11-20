import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/meno.dart';

import 'package:meno_fe_v1/src/features/notes/notes.dart';

part 'note_editor_event.dart';

part 'note_editor_state.dart';

part 'note_editor_bloc.freezed.dart';

class NoteEditorBloc extends Bloc<NoteEditorEvent, NoteEditorState> {
  NoteEditorBloc({
    required INoteFacade facade,
    Note? initialNote,
  })  : _facade = facade,
        super(
          NoteEditorState(
            note: initialNote ?? Note.empty(),
            isEditing: initialNote != null,
          ),
        ) {
    on<NoteTitleChanged>(_onTitleChanged);
    on<NoteContentChanged>(_onContentChanged);
    on<NoteSaveRequested>(_onNoteSaveRequested);
    on<NoteEditorExited>(_onExited);
  }

  final INoteFacade _facade;

  void _onTitleChanged(NoteTitleChanged event, Emitter<NoteEditorState> emit) {
    emit(state.copyWith(note: state.note.copyWith(title: event.title)));
  }

  void _onContentChanged(
    NoteContentChanged event,
    Emitter<NoteEditorState> emit,
  ) {
    emit(state.copyWith(note: state.note.copyWith(content: event.content)));
  }

  Future<void> _onNoteSaveRequested(
    NoteSaveRequested event,
    Emitter<NoteEditorState> emit,
  ) async {
    late Either<NoteException, Note> failureOrNote;

    emit(state.copyWith(status: NoteEditorStatus.loading));

    if (state.note.failureOption.isNone()) {
      failureOrNote = state.isEditing
          ? await _facade.updateNote(note: state.note)
          : await _facade.createNote(state.note);
    }

    emit(
      failureOrNote.fold(
        (f) => state.copyWith(status: NoteEditorStatus.failure, failure: f),
        (n) => state.copyWith(status: NoteEditorStatus.saved, note: n),
      ),
    );
  }

  void _onExited(NoteEditorExited event, Emitter<NoteEditorState> emit) {}
}

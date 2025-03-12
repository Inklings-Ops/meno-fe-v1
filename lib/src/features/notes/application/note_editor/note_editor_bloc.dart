import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

part 'note_editor_bloc.freezed.dart';
part 'note_editor_event.dart';
part 'note_editor_state.dart';

class NoteEditorBloc extends Bloc<NoteEditorEvent, NoteEditorState> {
  NoteEditorBloc({required INoteFacade facade})
      : _facade = facade,
        super(NoteLoaded(Note.empty())) {
    on<InitializeNoteEditor>(_onInit);
    on<NoteTitleChanged>(_onTitleChanged);
    on<NoteContentChanged>(_onContentChanged);
    on<NoteSaveRequested>(_onNoteSaveRequested);
    on<NoteEditorExited>(_onExited);
  }

  final INoteFacade _facade;

  bool get isNoteEmpty {
    return state.maybeWhen(
      orElse: () => true,
      loaded: (note) => !(note.title.isValid && note.content.isValid),
    );
  }

  bool get isDoneEditingAndValid {
    return state.maybeWhen(
      orElse: () => false,
      loaded: (note) => note.uid.isValid && note.title.isValid,
    );
  }

  void _onInit(InitializeNoteEditor event, Emitter<NoteEditorState> emit) {
    return emit(NoteLoaded(event.note));
  }

  void _onTitleChanged(NoteTitleChanged event, Emitter<NoteEditorState> emit) {
    if (state is! NoteLoaded) return;
    final note = (state as NoteLoaded).note.copyWith(title: event.title);
    return emit(NoteLoaded(note));
  }

  void _onContentChanged(
    NoteContentChanged event,
    Emitter<NoteEditorState> emit,
  ) {
    if (state is! NoteLoaded) return;
    final note = (state as NoteLoaded).note.copyWith(content: event.content);
    return emit(NoteLoaded(note));
  }

  Future<void> _onNoteSaveRequested(
    NoteSaveRequested event,
    Emitter<NoteEditorState> emit,
  ) async {
    if (state is NoteSaveInProgress) return;

    if (state is NoteLoaded) {
      final note = (state as NoteLoaded).note;

      emit(const NoteSaveInProgress());

      if (note.title.isValid) {
        final failureOrNote = note.uid.isValid
            ? await _facade.updateNote(note: note)
            : await _facade.createNote(note);

        emit(failureOrNote.fold(NoteEditorFailure.new, NoteSaved.new));
      }
    }
  }

  void _onExited(NoteEditorExited event, Emitter<NoteEditorState> emit) {}
}

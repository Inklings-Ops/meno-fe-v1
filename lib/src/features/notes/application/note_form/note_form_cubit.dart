import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';


part 'note_form_cubit.freezed.dart';
part 'note_form_state.dart';

@injectable
class NoteFormCubit extends Cubit<NoteFormState> {
  NoteFormCubit({
    required INoteFacade facade,
    @factoryParam Note? initialNote,
  })  : _facade = facade,
        _initialNote = initialNote,
        super(NoteFormState.initial()) {
    if (_initialNote != null) {
      emit(state.copyWith(note: _initialNote!, isEditing: true));
    }
  }
  final INoteFacade _facade;
  final Note? _initialNote;

  Timer? _debounce;

  void titleChanged(String title) {
    final updatedNote = state.note.copyWith(title: NoteTitle(title));
    emit(state.copyWith(note: updatedNote, option: none()));
    _autoSaveNote();
  }

  void contentChanged(String content) {
    final updatedNote = state.note.copyWith(content: NoteContent(content));
    emit(state.copyWith(note: updatedNote, option: none()));
    _autoSaveNote();
  }

  Future<void> onSubmit() async {
    late Either<NoteException, Note> fOrS;
    emit(state.copyWith(loading: true, option: none()));
    if (state.note.failureOption.isNone()) {
      fOrS = state.isEditing
          ? await _facade.updateNote(note: state.note)
          : await _facade.createNote(state.note);
      fOrS.fold(
        (failure) => null,
        (note) => emit(state.copyWith(note: note)),
      );
    }
    emit(state.copyWith(
      option: optionOf(fOrS),
      loading: false,
    ),);
  }

  void _autoSaveNote() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(
      const Duration(seconds: 10),
      () async => onSubmit(),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

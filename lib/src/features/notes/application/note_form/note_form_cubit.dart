import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';
import '../../domain/exceptions/note_exception.dart';

part 'note_form_cubit.freezed.dart';
part 'note_form_state.dart';

@lazySingleton
class NoteFormCubit extends Cubit<NoteFormState> {
  final INoteFacade _facade;

  NoteFormCubit({
    required INoteFacade facade,
  })  : _facade = facade,
        super(NoteFormState.initial());

  Timer? _debounce;

  void init(Note initialNote) {
    emit(NoteFormState.initial().copyWith(
      initialNote: initialNote,
      title: initialNote.title,
      content: initialNote.content,
    ));
  }

  void titleChanged(String title) {
    emit(state.copyWith(title: INoteTitle(title)));
    _autoSaveNote();
  }

  void contentChanged(String content) {
    emit(state.copyWith(content: INoteContent(content)));
    _autoSaveNote();
  }

  Future<void> onSubmit() async {
    final isTitleValid = state.title.isValid();
    final isContentValid = state.content.isValid();

    if (isTitleValid && isContentValid) {
      emit(state.copyWith(loading: true, option: none()));

      final result = state.initialNote != null
          ? await _updateNote(state.initialNote!)
          : await _createNote();

      emit(state.copyWith(
        option: some(result),
        loading: false,
        initialNote: result.fold((_) => null, (note) => note),
      ));
    }
  }

  Future<Either<NoteException, Note>> _createNote() async {
    return _facade.createNote(title: state.title, content: state.content);
  }

  Future<Either<NoteException, Note>> _updateNote(Note initialNote) async {
    return await _facade.updateNote(
      id: state.initialNote!.id!,
      title: state.title,
      content: state.content,
    );
  }

  void _autoSaveNote() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(
      const Duration(seconds: 10),
      () async => await onSubmit(),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

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

  void titleChanged(String title) {
    emit(state.copyWith(title: INoteTitle(title), option: none()));
  }

  void contentChanged(String content) {
    emit(state.copyWith(content: INoteContent(content), option: none()));
  }

  Future<void> createNote() async {
    final isTitleValid = state.title.isValid();
    final isContentValid = state.content.isValid();

    if (!isTitleValid || !isContentValid) return;

    emit(state.copyWith(loading: true, option: none()));

    await _facade.createNote(title: state.title, content: state.content).then(
      (result) {
        emit(state.copyWith(option: some(result), loading: false));
      },
    );
  }

  Future<void> editNote() async {}
}

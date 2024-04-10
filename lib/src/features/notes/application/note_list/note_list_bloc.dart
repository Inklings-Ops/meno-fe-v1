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
  }

  Future<void> _onGetAllNotes(event, emit) async {
    emit(const _Loading());

    final result = await _facade.getAllNotes();

    return result.fold(
      (failure) => emit(const _Failure()),
      (notes) => notes.isEmpty ? emit(const _Empty()) : emit(_Success(notes)),
    );
  }
}

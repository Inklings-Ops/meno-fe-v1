import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/bible/domain/domain.dart';

part 'bible_bloc.freezed.dart';
part 'bible_event.dart';
part 'bible_state.dart';

class BibleBloc extends Bloc<BibleEvent, BibleState> {
  BibleBloc({required IBibleFacade facade})
      : _facade = facade,
        super(BibleState.initial()) {
    on<_Download>(_onDownload);
    on<_Initialize>(_initialize);
    on<_GetVerses>(_onGetVerses);

    add(const BibleEvent.initialize());
  }
  final IBibleFacade _facade;

  List<MapEntry<String, int>> get books => _facade.books.entries.toList();

  Future<void> _onDownload(_Download event, Emitter<BibleState> emit) async {
    emit(state.copyWith(loading: true));
    final response = await _facade.sync(
      translation: event.translation ?? 'kjv',
    );

    return response.fold(
      (failure) => emit(
        state.copyWith(
          loading: false,
          downloadOption: some(response),
        ),
      ),
      (success) => emit(
        state.copyWith(
          loading: false,
          downloadOption: some(response),
        ),
      ),
    );
  }

  Future<void> _initialize(_Initialize event, Emitter<BibleState> emit) async {
    emit(state.copyWith(loading: true));

    final verses = _facade.getVerses(
      book: state.book,
      chapter: state.chapter,
      translation: state.translation,
    );

    emit(state.copyWith(verses: verses, loading: false));
  }

  Future<void> _onGetVerses(_GetVerses event, Emitter<BibleState> emit) async {
    final verses = _facade.getVerses(
      book: state.book,
      chapter: state.chapter,
      translation: state.translation,
    );

    emit(state.copyWith(verses: verses));
  }
}

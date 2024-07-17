import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

part 'bible_bloc.freezed.dart';
part 'bible_event.dart';
part 'bible_state.dart';

@injectable
class BibleBloc extends Bloc<BibleEvent, BibleState> {
  final IBibleFacade _facade;
  BibleBloc({required IBibleFacade facade})
      : _facade = facade,
        super(BibleState.initial()) {
    on<_Download>(_onDownload);
    on<_Initialize>(_initialize);
    on<_GetVerses>(_onGetVerses);
  }
  void init() => add(const BibleEvent.initialize());
  
  List<MapEntry<String, int>> get books => _facade.books.entries.toList();

  _onDownload(_Download event, Emitter<BibleState> emit) async {
    emit(state.copyWith(loading: true));
    final response = await _facade.sync(
      translation: event.translation ?? 'kjv',
    );

    return response.fold(
      (failure) => emit(state.copyWith(
        loading: false,
        downloadOption: some(response),
      )),
      (success) => emit(state.copyWith(
        loading: false,
        downloadOption: some(response),
      )),
    );
  }

  _initialize(_Initialize event, Emitter<BibleState> emit) async {
    emit(state.copyWith(loading: true));

    final verses = _facade.getVerses(
      book: state.book,
      chapter: state.chapter,
      translation: state.translation,
    );

    emit(state.copyWith(verses: verses, loading: false));
  }

  _onGetVerses(_GetVerses event, Emitter<BibleState> emit) async {
    final verses = _facade.getVerses(
      book: state.book,
      chapter: state.chapter,
      translation: state.translation,
    );

    emit(state.copyWith(verses: verses));
  }
}

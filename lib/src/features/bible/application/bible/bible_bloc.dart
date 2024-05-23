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
  BibleBloc({required IBibleFacade facade})
      : _facade = facade,
        super(BibleState.initial()) {
    on<_Download>(_onDownload);
    on<_Initialize>(_initialize);
    on<_GetVerses>(_onGetVerses);
    on<_BookChanged>(_onBookChanged);
    on<_ChapterChanged>(_onChapterChanged);
    on<_VerseChanged>(_onVerseChanged);
    on<_TranslationChanged>(_onTranslationChanged);
    on<_NextChapter>(_onNextChapter);
    on<_PreviousChapter>(_onPreviousChapter);
  }
  final IBibleFacade _facade;

  List<MapEntry<String, int>> get books => _facade.books.entries.toList();

  bool get isPreviousEnabled {
    final firstBook = books.first;
    if (state.book == firstBook.key && state.chapter == 1) {
      return false;
    } else {
      return true;
    }
  }

  bool get isNextEnabled {
    final lastBook = books.last;
    if (state.book == lastBook.key && state.chapter == lastBook.value) {
      return false;
    } else {
      return true;
    }
  }

  _onDownload(_Download event, Emitter<BibleState> emit) async {
    emit(state.copyWith(loading: true));
    final response = await _facade.sync(event.translation ?? 'kjv');

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

  _onBookChanged(_BookChanged event, Emitter<BibleState> emit) async {
    emit(state.copyWith(book: event.book));
  }

  _onChapterChanged(_ChapterChanged event, Emitter<BibleState> emit) async {
    final verses = _facade.getVerses(
      book: state.book,
      chapter: event.chapter,
      translation: state.translation,
    );

    emit(state.copyWith(
      verses: verses,
      chapter: event.chapter,
      reference: '${state.book} ${event.chapter}',
    ));
  }

  _onVerseChanged(_VerseChanged event, Emitter<BibleState> emit) async {
    emit(state.copyWith(verse: event.verse));
  }

  _onTranslationChanged(
    _TranslationChanged event,
    Emitter<BibleState> emit,
  ) async {
    emit(state.copyWith(translation: event.translation));
  }

  _onNextChapter(_NextChapter event, Emitter<BibleState> emit) async {
    if (isNextEnabled) {
      final currentBookChapter = _facade.books[state.book]!;

      if (state.chapter < currentBookChapter) {
        emit(state.copyWith(
          chapter: state.chapter + 1,
          reference: '${state.book} ${state.chapter + 1}',
        ));
      } else {
        final currentBookIndex = books.indexWhere((b) => b.key == state.book);

        if (currentBookIndex != -1 && currentBookIndex < books.length - 1) {
          final nextBook = books[currentBookIndex + 1].key;

          emit(state.copyWith(
            book: nextBook,
            chapter: 1,
            reference: '$nextBook 1',
          ));
        }
      }

      final verses = _facade.getVerses(
        book: state.book,
        chapter: state.chapter,
        translation: state.translation,
      );

      emit(state.copyWith(verses: verses));
    }
  }

  _onPreviousChapter(_PreviousChapter event, Emitter<BibleState> emit) async {
    if (isPreviousEnabled) {
      if (state.chapter > 1) {
        emit(state.copyWith(
          chapter: state.chapter - 1,
          reference: '${state.book} ${state.chapter - 1}',
        ));
      } else {
        final currentBookIndex = books.indexWhere((b) => b.key == state.book);

        if (currentBookIndex != -1 && currentBookIndex > 0) {
          final previousBook = books[currentBookIndex - 1];

          emit(state.copyWith(
            book: previousBook.key,
            chapter: previousBook.value,
            reference: '${previousBook.key} ${previousBook.value}',
          ));
        }
      }
    }

    final verses = _facade.getVerses(
      book: state.book,
      chapter: state.chapter,
      translation: state.translation,
    );

    emit(state.copyWith(verses: verses));
  }
}

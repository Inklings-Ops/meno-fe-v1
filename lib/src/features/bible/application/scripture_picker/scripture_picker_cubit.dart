import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/bible/domain/domain.dart';

part 'scripture_picker_cubit.freezed.dart';
part 'scripture_picker_state.dart';

@injectable
class ScripturePickerCubit extends Cubit<ScripturePickerState> {
  ScripturePickerCubit({required IBibleFacade facade})
      : _facade = facade,
        super(ScripturePickerState.initial());

  final IBibleFacade _facade;

  Map<String, int> get books => _facade.books;

  List<MapEntry<String, int>> get _books => books.entries.toList();

  bool get isPreviousEnabled {
    final firstBook = _books.first;
    if (state.book == firstBook.key && state.chapter == 1) {
      return false;
    } else {
      return true;
    }
  }

  bool get isNextEnabled {
    final lastBook = _books.last;
    if (state.book == lastBook.key && state.chapter == lastBook.value) {
      return false;
    } else {
      return true;
    }
  }

  void bookChanged(String book) {
    final chapterLength = books[book]!;
    emit(state.copyWith(book: book, chapterLength: chapterLength));
  }

  void chapterChanged(int chapter) {
    final reference = '${state.book} $chapter';
    emit(state.copyWith(chapter: chapter, reference: reference));
  }

  void verseChanged(int verse) => emit(state.copyWith(verse: verse));

  Future<void> nextChapter() async {
    if (isNextEnabled) {
      final currentBookChapter = _facade.books[state.book]!;

      if (state.chapter < currentBookChapter) {
        emit(state.copyWith(
          chapter: state.chapter + 1,
          reference: '${state.book} ${state.chapter + 1}',
        ),);
      } else {
        final currentBookIndex = _books.indexWhere((b) => b.key == state.book);

        if (currentBookIndex != -1 && currentBookIndex < books.length - 1) {
          final nextBook = _books[currentBookIndex + 1].key;

          emit(state.copyWith(
            book: nextBook,
            chapter: 1,
            reference: '$nextBook 1',
          ),);
        }
      }
    }
  }

  Future<void> previousChapter() async {
    if (isPreviousEnabled) {
      if (state.chapter > 1) {
        emit(state.copyWith(
          chapter: state.chapter - 1,
          reference: '${state.book} ${state.chapter - 1}',
        ),);
      } else {
        final currentBookIndex = _books.indexWhere((b) => b.key == state.book);

        if (currentBookIndex != -1 && currentBookIndex > 0) {
          final previousBook = _books[currentBookIndex - 1];

          emit(state.copyWith(
            book: previousBook.key,
            chapter: previousBook.value,
            reference: '${previousBook.key} ${previousBook.value}',
          ),);
        }
      }
    }
  }
}

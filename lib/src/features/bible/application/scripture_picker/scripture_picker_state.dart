part of 'scripture_picker_cubit.dart';

final class ScripturePickerState with EquatableMixin {
  const ScripturePickerState() : this._();

  const ScripturePickerState._({
    this.reference = 'Genesis 1',
    this.book = 'Genesis',
    this.chapterLength = 50,
    this.chapter = 1,
    this.verse,
  });

  ScripturePickerState withBook({
    required String book,
    required int chapterLength,
  }) {
    return ScripturePickerState._(
      reference: reference,
      book: book,
      chapterLength: chapterLength,
      chapter: chapter,
      verse: verse,
    );
  }

  ScripturePickerState withReferenceChapter({
    required String reference,
    required int chapter,
  }) {
    return ScripturePickerState._(
      reference: reference,
      book: book,
      chapterLength: chapterLength,
      chapter: chapter,
      verse: verse,
    );
  }

  ScripturePickerState withBookChapterReference({
    required String reference,
    required String book,
    required int chapter,
  }) {
    return ScripturePickerState._(
      reference: reference,
      book: book,
      chapterLength: chapterLength,
      chapter: chapter,
      verse: verse,
    );
  }

  ScripturePickerState withVerse(int verse) {
    return ScripturePickerState._(
      reference: reference,
      book: book,
      chapterLength: chapterLength,
      chapter: chapter,
      verse: verse,
    );
  }

  final String reference;
  final String book;
  final int chapterLength;
  final int chapter;
  final int? verse;

  @override
  List<Object?> get props => [reference, book, chapterLength, chapter, verse];
}

part of 'bible_bloc.dart';

@freezed
class BibleState with _$BibleState {
  const factory BibleState({
    required String book,
    required int chapter,
    required String translation,
    required List<Verse> verses,
    required List<Translation> translations,
    required Option<Either<BibleException, Translation>> downloadOption,
    required bool loading,
    required String reference,
    int? verse,
  }) = _BibleState;

  factory BibleState.initial() {
    return BibleState(
      reference: 'Genesis 1',
      book: 'Genesis',
      chapter: 1,
      translation: 'kjv',
      verses: [],
      translations: [],
      downloadOption: none(),
      loading: false,
    );
  }
}

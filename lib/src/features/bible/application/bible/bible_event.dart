part of 'bible_bloc.dart';

@freezed
class BibleEvent with _$BibleEvent {
  const factory BibleEvent.download([String? translation]) = _Download;
  const factory BibleEvent.initialize() = _Initialize;
  const factory BibleEvent.getVerses() = _GetVerses;

  const factory BibleEvent.bookChanged(String book) = _BookChanged;
  const factory BibleEvent.chapterChanged(int chapter) = _ChapterChanged;
  const factory BibleEvent.verseChanged(int verse) = _VerseChanged;
  const factory BibleEvent.translationChanged(String translation) =
      _TranslationChanged;

  const factory BibleEvent.nextChapter() = _NextChapter;
  const factory BibleEvent.previousChapter() = _PreviousChapter;
}

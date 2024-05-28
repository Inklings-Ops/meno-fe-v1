part of 'scripture_picker_cubit.dart';

@freezed
class ScripturePickerState with _$ScripturePickerState {
  const factory ScripturePickerState({
    required String reference,
    required String book,
    required int chapterLength,
    required int chapter,
    int? verse,
  }) = _ScripturePickerState;

  factory ScripturePickerState.initial() {
    return const ScripturePickerState(
      reference: 'Genesis 1',
      book: 'Genesis',
      chapterLength: 50,
      chapter: 1,
      verse: null,
    );
  }
}

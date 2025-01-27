part of 'translation_bloc.dart';

@freezed
class TranslationState with _$TranslationState {
  const factory TranslationState({
    required Translation translation,
  }) = _TranslationState;

  factory TranslationState.initial() {
    return const TranslationState(
      translation: Translation(
        abbreviation: 'kjv',
        name: 'King James Version',
      ),
    );
  }
}

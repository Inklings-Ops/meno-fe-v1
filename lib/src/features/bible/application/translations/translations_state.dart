part of 'translations_cubit.dart';

@freezed
class TranslationsState with _$TranslationsState {
  const factory TranslationsState({
    required List<Translation> onlineTranslations,
    required List<Translation> offlineTranslations,
    required List<Translation> translations,
    required Translation selectedTranslation,
  }) = _TranslationsState;

  factory TranslationsState.initial() {
    return const TranslationsState(
      onlineTranslations: [],
      offlineTranslations: [],
      translations: [],
      selectedTranslation: Translation(
        abbreviation: 'kjv',
        name: 'King James Version',
      ),
    );
  }
}

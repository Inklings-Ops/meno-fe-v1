part of 'translations_cubit.dart';

@freezed
class TranslationsState with _$TranslationsState {
  const factory TranslationsState({
    required List<Translation> onlineTranslations,
    required List<Translation> offlineTranslations,
    required List<Translation> translations,
    required Translation selectedTranslation,
    required double downloadProgress,
     required bool loading,
    required bool cancelDownload,
    required Option<Either<BibleException, Translation>> downloadOption,
  }) = _TranslationsState;

  factory TranslationsState.initial() {
    return TranslationsState(
      onlineTranslations: [],
      offlineTranslations: [],
      translations: [],
      downloadProgress: 0.0,
       loading: false,
      cancelDownload: false,
      downloadOption: none(),
      selectedTranslation: Translation(
        abbreviation: 'kjv',
        name: 'King James Version',
      ),
    );
  }
}

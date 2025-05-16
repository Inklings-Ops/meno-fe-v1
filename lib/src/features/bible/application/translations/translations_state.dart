part of 'translations_bloc.dart';

@freezed
class TranslationsState with _$TranslationsState {
  const factory TranslationsState({
    @Default([]) List<Translation> localTranslations,
    @Default([]) List<Translation> remoteTranslations,
  }) = _TranslationsState;

}

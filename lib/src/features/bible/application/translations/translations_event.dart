part of 'translations_bloc.dart';

@freezed
class TranslationsEvent with _$TranslationsEvent {
  const factory TranslationsEvent.get() = GetTranslations;
  const factory TranslationsEvent.update(Translation translation) =
      UpdateTranslations;
}

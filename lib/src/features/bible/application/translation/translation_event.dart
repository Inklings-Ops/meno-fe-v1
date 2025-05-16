part of 'translation_bloc.dart';

@freezed
class TranslationEvent with _$TranslationEvent {
  const factory TranslationEvent.changeTranslation(
    Translation translation,
  ) = ChangeTranslation;
}

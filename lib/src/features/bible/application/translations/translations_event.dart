part of 'translations_bloc.dart';

sealed class TranslationsEvent with EquatableMixin {
  const TranslationsEvent();

  @override
  List<Object?> get props => [];
}

final class TranslationsFetchRequested extends TranslationsEvent {
  const TranslationsFetchRequested();
}

final class TranslationsUpdateRequested extends TranslationsEvent {
  const TranslationsUpdateRequested(this.translation);
  final Translation translation;

  @override
  List<Object?> get props => [translation];
}

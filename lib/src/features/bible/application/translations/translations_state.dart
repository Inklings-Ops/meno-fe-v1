part of 'translations_bloc.dart';

final class TranslationsState with EquatableMixin {
  const TranslationsState({
    this.localTranslations = const [],
    this.remoteTranslations = const [],
  });

  final List<Translation> localTranslations;
  final List<Translation> remoteTranslations;

  TranslationsState copyWith({
    List<Translation>? localTranslations,
    List<Translation>? remoteTranslations,
  }) {
    return TranslationsState(
      localTranslations: localTranslations ?? this.localTranslations,
      remoteTranslations: remoteTranslations ?? this.remoteTranslations,
    );
  }

  @override
  List<Object?> get props => [localTranslations, remoteTranslations];
}

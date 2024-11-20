part of 'trans_bloc.dart';

@freezed
class TransState with _$TransState {
  const factory TransState({
    required Translation selectedTranslation,
    Translation? downloadingTranslation,
    @Default([]) List<Translation> storedTranslations,
    @Default([]) List<Translation> otherTranslations,
    @Default(false) bool downloading,
    @Default(0) double downloadProgress,
    @Default(None()) Option<Either<BibleException, Translation>> downloadOption,
  }) = _TransState;

  factory TransState.initial() {
    return const TransState(
      selectedTranslation: Translation(
        abbreviation: 'kjv',
        name: 'King James Version',
      ),
    );
  }
}

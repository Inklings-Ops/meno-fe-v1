part of 'verses_cubit.dart';

@freezed
class VersesState with _$VersesState {
  const factory VersesState({
    required List<Verse> verses,
  }) = _VersesState;

  factory VersesState.initial() => const VersesState(verses: []);
}

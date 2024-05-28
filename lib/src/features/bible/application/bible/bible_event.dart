part of 'bible_bloc.dart';

@freezed
class BibleEvent with _$BibleEvent {
  const factory BibleEvent.download([String? translation]) = _Download;
  const factory BibleEvent.initialize() = _Initialize;
  const factory BibleEvent.getVerses() = _GetVerses;
}

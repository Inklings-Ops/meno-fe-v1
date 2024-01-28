part of 'meno_bloc.dart';

@freezed
class MenoEvent with _$MenoEvent {
  const factory MenoEvent.stateChanged(MenoState state) = MenoStateChanged;
}
part of 'meno_event_provider.dart';

@freezed
class MenoState with _$MenoState {
  factory MenoState({
    required MenoEvent event,
    required Status status,
  }) = _MenoState;

  factory MenoState.initial() {
    return MenoState(
      event: const MenoEvent.isOffAir(),
      status: Status.offAir,
    );
  }
}

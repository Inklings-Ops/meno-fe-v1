part of 'live_kit_service.dart';

@freezed
class LiveKitState with _$LiveKitState {
  factory LiveKitState({
    Room? room,
    LocalParticipant? participant,
    EventsListener<RoomEvent>? listener,
    MenoEvent? event,
    required bool isLoading,
  }) = _LiveKitState;

  factory LiveKitState.initial() => LiveKitState(isLoading: false);
}

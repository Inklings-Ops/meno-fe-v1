part of 'live_kit_bloc.dart';

@freezed
class LiveKitEvent with _$LiveKitEvent {
  const factory LiveKitEvent.broadcast(String token) = LiveKitBroadcast;
  const factory LiveKitEvent.stream(String token) = LiveKitStream;
  const factory LiveKitEvent.disconnect() = LiveKitDisconnect;
  const factory LiveKitEvent.mute() = LiveKitToggleMute;
}

part of 'live_kit_bloc.dart';

@freezed
class LiveKitEvent with _$LiveKitEvent {
  const factory LiveKitEvent.broadcast({
    String? token,
    @Default(false) bool isReconnect,
  }) = LiveKitBroadcast;
  const factory LiveKitEvent.stream({
    String? token,
    @Default(false) bool isReconnect,
  }) = LiveKitStream;
  const factory LiveKitEvent.disconnect() = LiveKitDisconnect;
  const factory LiveKitEvent.mute() = LiveKitToggleMute;
}

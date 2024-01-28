part of 'live_kit_bloc.dart';

@freezed
class LiveKitEvent with _$LiveKitEvent {
  ///  Called when a user starts a live broadcast or joins a stream.
  ///
  ///  If the user connecting to the live kit client is a broadcaster,
  ///  the microphone is un-mute by default, until the user mutes.
  ///
  ///  If the user connecting to the live kit client is a participant joining the
  ///  a live broadcast, then the microphone is disabled.
  const factory LiveKitEvent.connect(
    String broadcastToken, [
    @Default(true) bool isHost,
  ]) = _ConnectRequested;

  /// Called when a broadcaster ends a broadcast or when participant in
  /// a live broadcast leaves the broadcast room
  const factory LiveKitEvent.disconnect() = _DisconnectRequested;

  /// Called when a user that is currently broadcasting wants to mute/unmute the microphone
  const factory LiveKitEvent.muteToggled(bool value) = _MuteToggled;
}

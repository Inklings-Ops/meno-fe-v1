part of 'broadcast_bloc.dart';

@freezed
class BroadcastEvent with _$BroadcastEvent {
  const factory BroadcastEvent.delete(String broadcastId) = _DeleteBroadcast;
  const factory BroadcastEvent.end() = _EndBroadcast;
  const factory BroadcastEvent.initialize(Broadcast broadcast) = _Initialize;
  const factory BroadcastEvent.mute(bool value) = _MuteMicrophone;
  const factory BroadcastEvent.start() = _StartBroadcast;
}

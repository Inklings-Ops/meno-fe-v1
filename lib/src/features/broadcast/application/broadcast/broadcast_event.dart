part of 'broadcast_bloc.dart';

@freezed
class BroadcastEvent with _$BroadcastEvent {
  const factory BroadcastEvent.initialize(Broadcast broadcast) =
      BroadcastInitialized;
  const factory BroadcastEvent.start() = BroadcastStartPressed;
  const factory BroadcastEvent.end(Uid<Broadcast> broadcastId) =
      BroadcastEndPressed;
  const factory BroadcastEvent.muteToggled() = BroadcastMuteToggled;
  const factory BroadcastEvent.reset() = BroadcastReset;
  const factory BroadcastEvent.socketDataReceived({
    dynamic data,
    String? error,
  }) = _SocketDataReceived;
}

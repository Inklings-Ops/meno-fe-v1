part of 'broadcast_bloc.dart';

@freezed
class BroadcastEvent with _$BroadcastEvent {
  const factory BroadcastEvent.start(Broadcast broadcast) =
      BroadcastStartPressed;
  const factory BroadcastEvent.reconnect(Broadcast broadcast) =
      BroadcastReconnectRequested;
  const factory BroadcastEvent.reset() = BroadcastReset;
}

part of 'broadcast_bloc.dart';

@freezed
class BroadcastEvent with _$BroadcastEvent {
  const factory BroadcastEvent.start(Uid<Broadcast> id) = BroadcastStartRequested;
  const factory BroadcastEvent.mute(bool value) = BroadcastMuteMicrophone;
  const factory BroadcastEvent.end(Uid<Broadcast> id) = BroadcastEndRequested;
  const factory BroadcastEvent.delete(Uid<Broadcast> id) = BroadcastDeleteRequested;
}
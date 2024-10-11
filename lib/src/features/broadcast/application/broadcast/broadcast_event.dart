// ignore_for_file: avoid_positional_boolean_parameters

part of 'broadcast_bloc.dart';

@freezed
class BroadcastEvent with _$BroadcastEvent {
  const factory BroadcastEvent.start() = BroadcastStartRequested;
  const factory BroadcastEvent.mute(bool value) = BroadcastMuteMicrophone;
  const factory BroadcastEvent.end() = BroadcastEndRequested;
  const factory BroadcastEvent.delete(Uid<Broadcast> id) = BroadcastDeleteRequested;
}
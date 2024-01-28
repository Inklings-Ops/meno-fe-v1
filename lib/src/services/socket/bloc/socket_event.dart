part of 'socket_bloc.dart';

@freezed
class SocketEvent with _$SocketEvent {
  const factory SocketEvent.connect() = _Connect;
  const factory SocketEvent.disconnect() = _Disconnect;
  const factory SocketEvent.startBroadcast(String broadcastId) = _StartBroadcast;
  const factory SocketEvent.endBroadcast(String broadcastId) = _EndBroadcast;
  const factory SocketEvent.joinBroadcast(String broadcastId) = _JoinBroadcast;
  const factory SocketEvent.leaveBroadcast(String broadcastId) = _LeaveBroadcast;
  const factory SocketEvent.getLiveBroadcasts() = _GetLiveBroadcasts;
  const factory SocketEvent.getLiveParticipants(String broadcastId) = _GetLiveParticipants;
  const factory SocketEvent.newBroadcast(dynamic data) = _NewBroadcast;
  const factory SocketEvent.numberOfLiveListeners(dynamic data) = _NumberOfLiveListeners;
  const factory SocketEvent.newBroadcastListener(dynamic data) = _NewBroadcastListener;
  const factory SocketEvent.endedBroadcast(dynamic data) = _EndedBroadcast;
}


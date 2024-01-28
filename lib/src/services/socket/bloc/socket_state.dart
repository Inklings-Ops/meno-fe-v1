part of 'socket_bloc.dart';

@freezed
class SocketState with _$SocketState {
  const factory SocketState.disconnected() = _Disconnected;
  const factory SocketState.connected() = _Connected;
  const factory SocketState.loading() = _Loading;
  const factory SocketState.newBroadcastListenerData(dynamic data) = _NewBroadcastListenerData;
  const factory SocketState.numberOfLiveListenersData(dynamic data) = _NumberOfLiveListenersData;
  const factory SocketState.liveBroadcastsData(dynamic data) = _LiveBroadcastsData;
  const factory SocketState.liveListenersData(dynamic data) = _LiveListenersData;
  const factory SocketState.newBroadcastData(dynamic data) = _NewBroadcastData;
  const factory SocketState.endedBroadcastData() = _EndedBroadcastData;
}

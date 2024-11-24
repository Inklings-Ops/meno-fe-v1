part of 'socket_bloc.dart';

@freezed
class SocketState with _$SocketState {
  const factory SocketState.connectInProgress() = SocketConnectInProgress;

  const factory SocketState.connected() = SocketConnected;

  const factory SocketState.disconnected() = SocketDisconnected;

  const factory SocketState.error({
    required String error,
    @Default(false) bool isStream,
  }) = SocketError;

  const factory SocketState.loading() = SocketLoading;

  const factory SocketState.broadcastStarted() = SocketBroadcastStarted;

  const factory SocketState.broadcastEnded() = SocketBroadcastEnded;

  const factory SocketState.broadcastJoined() = SocketBroadcastJoined;

  const factory SocketState.broadcastLeft() = SocketBroadcastLeft;

  const factory SocketState.messagesReceived(
    List<Chat?> chats,
  ) = SocketMessagesReceived;

  const factory SocketState.newBroadcastListener(
    BroadcastParticipant participant,
  ) = SocketNewBroadcastListenerReceived;

  const factory SocketState.broadcastListenerLeft(
    BroadcastParticipant participant,
  ) = SocketBroadcastListenerLeftReceived;

  const factory SocketState.endedBroadcast(
    EndedBroadcastData data,
  ) = SocketEndedBroadcastReceived;

  const factory SocketState.newBroadcast(
    Broadcast broadcast,
  ) = SocketNewBroadcastReceived;

  const factory SocketState.hostDisconnected(
    bool value,
  ) = SocketHostDisconnectedReceived;

  const factory SocketState.hostReconnected(
    bool value,
  ) = SocketReconnectedReceived;

  const factory SocketState.notification(
    Notification notification,
  ) = SocketNotificationReceived;

  const factory SocketState.newMessage(
    Chat chat,
  ) = SocketNewMessageReceived;
}

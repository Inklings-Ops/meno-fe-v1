part of 'socket_bloc.dart';

sealed class SocketState with EquatableMixin {
  const SocketState();

  @override
  List<Object?> get props => [];
}

final class SocketConnectInProgress extends SocketState {
  const SocketConnectInProgress();
}

final class SocketConnected extends SocketState {
  const SocketConnected();
}

final class SocketDisconnected extends SocketState {
  const SocketDisconnected();
}

final class SocketError extends SocketState {
  const SocketError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// Event: newBroadcastListener
final class SocketNewParticipantReceived extends SocketState {
  const SocketNewParticipantReceived(this.participant);
  final BroadcastParticipant participant;

  @override
  List<Object?> get props => [participant];
}

// Event: broadcastListenerLeft
final class SocketParticipantLeftReceived extends SocketState {
  const SocketParticipantLeftReceived(this.participant);
  final BroadcastParticipant participant;

  @override
  List<Object?> get props => [participant];
}

// Event: endedBroadcast
final class SocketEndedBroadcastReceived extends SocketState {
  const SocketEndedBroadcastReceived(this.data);
  final EndedBroadcastData data;

  @override
  List<Object?> get props => [data];
}

// Event: newBroadcast
final class SocketNewBroadcastReceived extends SocketState {
  const SocketNewBroadcastReceived(this.broadcast);
  final Broadcast broadcast;

  @override
  List<Object?> get props => [broadcast];
}

// Event: hostDisconnected
final class SocketHostDisconnectedReceived extends SocketState {
  const SocketHostDisconnectedReceived(this.value);
  final bool value;

  @override
  List<Object?> get props => [value];
}

// Event: hostReconnected
final class SocketHostReconnectedReceived extends SocketState {
  const SocketHostReconnectedReceived(this.value);
  final bool value;

  @override
  List<Object?> get props => [value];
}

final class SocketNotificationReceived extends SocketState {
  const SocketNotificationReceived(this.notification);
  final Notification notification;

  @override
  List<Object?> get props => [notification];
}

final class SocketDeletedChatReceived extends SocketState {
  const SocketDeletedChatReceived(this.chat);
  final Chat chat;

  @override
  List<Object?> get props => [chat];
}

final class SocketEditedChatReceived extends SocketState {
  const SocketEditedChatReceived(this.chat);
  final Chat chat;

  @override
  List<Object?> get props => [chat];
}

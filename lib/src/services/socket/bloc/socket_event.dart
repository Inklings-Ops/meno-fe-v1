part of 'socket_bloc.dart';

sealed class SocketEvent with EquatableMixin {
  const SocketEvent();

  @override
  List<Object?> get props => [];
}

final class SocketConnectRequested extends SocketEvent {
  const SocketConnectRequested();
}

final class SocketDisconnectRequested extends SocketEvent {
  const SocketDisconnectRequested();
}

final class _Update extends SocketEvent {
  const _Update(this.state);
  final SocketState state;

  @override
  List<Object?> get props => [state];
}

final class SocketUpdateStateRequested extends SocketEvent {
  const SocketUpdateStateRequested(this.newState);
  final SocketState newState;

  @override
  List<Object?> get props => [newState];
}

final class SocketNewParticipantSubscribed extends SocketEvent {
  const SocketNewParticipantSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class SocketParticipantLeftSubscribed extends SocketEvent {
  const SocketParticipantLeftSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class SocketEndedBroadcastSubscribed extends SocketEvent {
  const SocketEndedBroadcastSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class SocketNewBroadcastSubscribed extends SocketEvent {
  const SocketNewBroadcastSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class SocketHostDisconnectedSubscribed extends SocketEvent {
  const SocketHostDisconnectedSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class SocketHostReconnectedSubscribed extends SocketEvent {
  const SocketHostReconnectedSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class SocketNotificationSubscribed extends SocketEvent {
  const SocketNotificationSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class SocketEditedChatSubscribed extends SocketEvent {
  const SocketEditedChatSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class SocketDeletedChatSubscribed extends SocketEvent {
  const SocketDeletedChatSubscribed(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

part of 'socket_bloc.dart';

@freezed
class SocketEvent with _$SocketEvent {
  const factory SocketEvent.connect(Token token) = SocketConnect;

  const factory SocketEvent.disconnect() = SocketDisconnect;

  const factory SocketEvent.updateState(
    SocketState newState,
  ) = SocketUpdateState;

  const factory SocketEvent.startBroadcast(
    Uid<Broadcast> broadcastId,
  ) = SocketStartBroadcast;

  const factory SocketEvent.endBroadcast(
    Uid<Broadcast> broadcastId,
  ) = SocketEndBroadcast;

  const factory SocketEvent.joinBroadcast(
    Uid<Broadcast> broadcastId,
  ) = SocketJoinBroadcast;

  const factory SocketEvent.leaveBroadcast(
    Uid<Broadcast> broadcastId,
  ) = SocketLeaveBroadcast;

  const factory SocketEvent.getMessages(
    Uid<Broadcast> broadcastId,
  ) = SocketGetMessages;

  const factory SocketEvent.sendMessage({
    required String senderId,
    required String broadcastId,
    required String content,
    required String createdAt,
  }) = SocketSendMessage;

  const factory SocketEvent.editMessage({
    required String id,
    required String senderId,
    required String broadcastId,
    required String content,
    required String createdAt,
    required String updatedAt,
  }) = SocketEditMessage;

  const factory SocketEvent.deleteChatMessage({
    required String id,
    required String senderId,
    required String broadcastId,
    required String content,
    required String createdAt,
  }) = SocketDeleteMessage;

  const factory SocketEvent.newParticipant(dynamic data) = _NewParticipant;

  const factory SocketEvent.participantLeft(dynamic data) = _ParticipantLeft;

  const factory SocketEvent.endedBroadcast(dynamic data) = _EndedBroadcast;

  const factory SocketEvent.newBroadcast(dynamic data) = _NewBroadcast;

  const factory SocketEvent.hostDisconnected(dynamic data) = _HostDisconnected;

  const factory SocketEvent.hostReconnected(dynamic data) = _HostReconnected;

  const factory SocketEvent.notification(dynamic data) = _Notification;

  const factory SocketEvent.newMessage(dynamic data) = _NewMessage;

  const factory SocketEvent.editedMessage(dynamic data) = _EditedMessage;

  const factory SocketEvent.deletedMessage(dynamic data) = _DeletedMessage;
}

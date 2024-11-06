import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/entities/notification.dart';

part 'socket_event.freezed.dart';

abstract class BroadcastEmittedEvent {}

abstract class BroadcastSubscribedEvent {}

abstract class NotificationSubscribedEvent {}

abstract class ChatEmittedEvent {}

abstract class ChatSubscribedEvent {}

@freezed
class SocketEvent with _$SocketEvent {
  // Emitted events
  @Implements<BroadcastEmittedEvent>()
  const factory SocketEvent.startedBroadcast(String broadcastId) =
      SocketStartedBroadcast;

  @Implements<BroadcastEmittedEvent>()
  const factory SocketEvent.joinBroadcast(String broadcastId) =
      SocketJoinBroadcast;

  @Implements<BroadcastEmittedEvent>()
  const factory SocketEvent.leaveBroadcast(String broadcastId) =
      SocketLeaveBroadcast;

  @Implements<BroadcastEmittedEvent>()
  const factory SocketEvent.endBroadcast(String broadcastId) =
      SocketEndBroadcast;

  @Implements<BroadcastEmittedEvent>()
  const factory SocketEvent.getLiveBroadcast(String broadcastId) =
      SocketGetLiveBroadcast;

  // Subscribe to the following events
  @Implements<BroadcastSubscribedEvent>()
  const factory SocketEvent.newBroadcastListener(
    BroadcastParticipant listener,
  ) = SocketNewBroadcastListener;

  @Implements<BroadcastSubscribedEvent>()
  const factory SocketEvent.broadcastListenerLeft(
    BroadcastParticipant listener,
  ) = SocketBroadcastListenerLeft;

  @Implements<BroadcastSubscribedEvent>()
  const factory SocketEvent.endedBroadcast(EndedBroadcastData data) =
      SocketEndedBroadcast;

  @Implements<BroadcastSubscribedEvent>()
  const factory SocketEvent.newBroadcast(Broadcast broadcast) =
      SocketNewBroadcast;

  @Implements<BroadcastSubscribedEvent>()
  const factory SocketEvent.hostDisconnected({required bool value}) =
      SocketBroadcastHostDisconnected;

  @Implements<BroadcastSubscribedEvent>()
  const factory SocketEvent.hostReconnected({required bool value}) =
      SocketBroadcastHostReconnected;

  @Implements<NotificationSubscribedEvent>()
  const factory SocketEvent.notification(Notification notification) =
      SocketNotification;

  @Implements<ChatEmittedEvent>()
  const factory SocketEvent.getChatMessages(String broadcastId) =
      SocketGetChatMessages;

  @Implements<ChatEmittedEvent>()
  const factory SocketEvent.sendChatMessage({
    required String senderId,
    required String broadcastId,
    required String content,
    required String createdAt,
  }) = SocketSendChatMessage;

  @Implements<ChatSubscribedEvent>()
  const factory SocketEvent.newMessage(Chat chat) = SocketNewMessage;
}

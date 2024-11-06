import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/domain/domain.dart';

part 'socket_state.freezed.dart';

@freezed
sealed class SocketState with _$SocketState {
  const factory SocketState.error(String error) = SocketError;
  const factory SocketState.broadcastStarted() = SocketBroadcastStarted;
  const factory SocketState.broadcastJoined() = SocketBroadcastJoined;
  const factory SocketState.getChatMessages(
    List<Chat?> data,
  ) = SocketChatMessagesReceived;
  const factory SocketState.getBroadcastListeners(
    List<BroadcastParticipant?> data,
  ) = SocketBroadcastListenersReceived;
  const factory SocketState.getNumberOfBroadcastListeners(
    int data,
  ) = SocketNumberOfBroadcastListenersReceived;
}

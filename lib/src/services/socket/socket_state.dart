import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/domain/domain.dart';

part 'socket_state.freezed.dart';

@freezed
sealed class SocketState with _$SocketState {
  const factory SocketState.broadcastStarted({
    dynamic data,
    String? error,
  }) = SocketBroadcastStarted;
  const factory SocketState.broadcastJoined({
    dynamic data,
    String? error,
  }) = SocketBroadcastJoined;
  const factory SocketState.getChatMessages(
    List<Chat?> data,
    dynamic error,
  ) = SocketChatMessagesReceived;
  const factory SocketState.getBroadcastListeners(
    List<BroadcastParticipant?> data,
    dynamic error,
  ) = SocketBroadcastListenersReceived;
  const factory SocketState.getNumberOfBroadcastListeners(
    int data,
    dynamic error,
  ) = SocketNumberOfBroadcastListenersReceived;
}

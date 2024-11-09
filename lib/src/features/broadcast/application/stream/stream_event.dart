part of 'stream_bloc.dart';

@freezed
class StreamEvent with _$StreamEvent {
  const factory StreamEvent.join(Uid<Broadcast> broadcastId,) = StreamJoinPressed;
  const factory StreamEvent.onJoined({
    dynamic data,
    String? error,
  }) = _StreamJoinReceived;
  const factory StreamEvent.leave(Uid<Broadcast> broadcastId,) = StreamLeavePressed;
  const factory StreamEvent.reset() = StreamReset;
  const factory StreamEvent.broadcastEnded(
    EndedBroadcastData data,
  ) = StreamEnded;
  const factory StreamEvent.socketDataReceived({
    dynamic data,
    String? error,
  }) = _SocketDataReceived;
}

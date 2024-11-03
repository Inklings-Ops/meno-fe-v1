part of 'stream_bloc.dart';

@freezed
class StreamEvent with _$StreamEvent {
  const factory StreamEvent.joined(Uid<Broadcast> id) = StreamJoinPressed;
  const factory StreamEvent.left(Uid<Broadcast> id) = StreamLeavePressed;
  const factory StreamEvent.broadcastEnded(EndedBroadcastData data,) = StreamEnded;
  const factory StreamEvent.socketDataReceived({dynamic data, String? error,}) = _SocketDataReceived;
  const factory StreamEvent.reset() = StreamReset;
}
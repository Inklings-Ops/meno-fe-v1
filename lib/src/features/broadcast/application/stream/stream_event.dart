part of 'stream_bloc.dart';

@freezed
class StreamEvent with _$StreamEvent {
  const factory StreamEvent.join(
    Uid<Broadcast> broadcastId,
  ) = StreamJoinPressed;
  const factory StreamEvent.reconnect() = StreamReconnectRequested;
  const factory StreamEvent.reset() = StreamReset;
}

part of 'stream_bloc.dart';

@freezed
class StreamEvent with _$StreamEvent {
   const factory StreamEvent.join(String broadcastId) = _JoinBroadcast;
  const factory StreamEvent.leave() = _LeaveBroadcast;
}
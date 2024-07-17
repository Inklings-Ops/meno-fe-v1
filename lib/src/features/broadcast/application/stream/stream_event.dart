part of 'stream_bloc.dart';

@freezed
class StreamEvent with _$StreamEvent {
  const factory StreamEvent.join(Uid<Broadcast> id) = StreamJoinRequested;
  const factory StreamEvent.leave(Uid<Broadcast> id) = StreamLeaveRequested;
}

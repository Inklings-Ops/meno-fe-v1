part of 'stream_bloc.dart';

@freezed
class StreamState with _$StreamState {
  const factory StreamState.loading() = StreamLoadInProgress;
  const factory StreamState.failure(BroadcastException exception) = StreamFailure;
  const factory StreamState.joinSuccess(Broadcast broadcast) = StreamJoinSuccess;
  const factory StreamState.joinFailed(Object? error) = StreamJoinedFailed;
  const factory StreamState.leaveSuccess() = StreamLeaveSuccess;
}

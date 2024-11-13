part of 'stream_bloc.dart';

@freezed
class StreamState with _$StreamState {
  const factory StreamState({
    required Broadcast broadcast,
    @Default(_Initial()) LiveStreamStatus status,
  }) = _StreamState;

  factory StreamState.initial() => StreamState(broadcast: Broadcast.empty());
}

@freezed
class LiveStreamStatus with _$LiveStreamStatus {
  const factory LiveStreamStatus.initial() = _Initial;
  const factory LiveStreamStatus.loadInProgress() = _LoadInProgress;
  const factory LiveStreamStatus.streamJoined() = _StreamJoined;
  const factory LiveStreamStatus.failure(BroadcastException exception) =
      _StreamFailure;
}

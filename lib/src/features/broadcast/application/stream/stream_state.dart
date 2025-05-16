part of 'stream_bloc.dart';

@freezed
class StreamState with _$StreamState {
  const factory StreamState({
    required Broadcast broadcast,
     String? broadcastToken,
    @Default(_Initial()) LiveStreamStatus status,
    @Default(false) bool isReconnect,
  }) = _StreamState;

  factory StreamState.initial() => StreamState(broadcast: Broadcast.empty());
}

@freezed
class LiveStreamStatus with _$LiveStreamStatus {
  const factory LiveStreamStatus.initial() = _Initial;
  const factory LiveStreamStatus.loadInProgress() = _LoadInProgress;
  const factory LiveStreamStatus.streamJoined(BroadcastToken token) =
      _StreamJoined;
  const factory LiveStreamStatus.failure(BroadcastException exception) =
      _StreamFailure;
}

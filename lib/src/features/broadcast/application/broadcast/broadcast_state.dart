part of 'broadcast_bloc.dart';

@freezed
class BroadcastState with _$BroadcastState {
  const factory BroadcastState({
    required Broadcast broadcast,
    @Default(false) bool hostDisconnected,
    @Default(false) bool isReconnect,
    @Default(_Initial()) LiveBroadcastStatus status,
  }) = _BroadcastState;

  factory BroadcastState.initial() {
    return BroadcastState(broadcast: Broadcast.empty());
  }
}

@freezed
class LiveBroadcastStatus with _$LiveBroadcastStatus {
  const factory LiveBroadcastStatus.initial() = _Initial;
  const factory LiveBroadcastStatus.loadInProgress() = _LoadInProgress;
  const factory LiveBroadcastStatus.broadcastStarted() = _BroadcastStarted;
  const factory LiveBroadcastStatus.failure(BroadcastException exception) =
      _BroadcastFailure;
}

part of 'broadcast_bloc.dart';

@freezed
class BroadcastState with _$BroadcastState {
  const factory BroadcastState({
    required Broadcast broadcast,
    @Default(false) bool hostDisconnected,
    @Default(LiveInitial()) LiveStatus status,
  }) = _BroadcastState;

  factory BroadcastState.initial() {
    return BroadcastState(broadcast: Broadcast.empty());
  }
}

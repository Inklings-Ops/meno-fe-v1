part of 'broadcast_bloc.dart';

@freezed
class BroadcastState with _$BroadcastState {
  const factory BroadcastState({
    required Broadcast broadcast,
    @Default(false) bool muted,
    @Default(LiveStatus.initial) LiveStatus status,
    BroadcastException? failure,
  }) = _BroadcastState;
}

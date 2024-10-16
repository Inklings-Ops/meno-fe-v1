part of 'broadcast_bloc.dart';

@freezed
class BroadcastState with _$BroadcastState {
  const factory BroadcastState({
    required Broadcast broadcast,
    @Default(LiveInitial()) LiveStatus status,
  }) = _BroadcastState;
}

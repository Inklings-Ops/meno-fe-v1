part of 'broadcast_bloc.dart';

@freezed
class BroadcastState with _$BroadcastState {
  const factory BroadcastState({
    required Broadcast broadcast,
    required bool loading,
    required bool isMute,
    required String? liveKitError,
    required Option<Either<BroadcastException, Broadcast>> onStarted,
    required Option<Either<BroadcastException, Unit>> onDeleted,
    required Option<Unit> onEnded,
  }) = _BroadcastState;

  factory BroadcastState.initial() {
    return BroadcastState(
      broadcast: Broadcast.empty(),
      loading: false,
      isMute: false,
      liveKitError: null,
      onStarted: none(),
      onDeleted: none(),
      onEnded: none(),
    );
  }
}

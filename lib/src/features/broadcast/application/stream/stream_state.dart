part of 'stream_bloc.dart';

@freezed
class StreamState with _$StreamState {
  factory StreamState({
    required JoinBroadcastEntity joinBroadcast,
    required bool loading,
    required String? liveKitError,
    required Option<Either<BroadcastException, JoinBroadcastEntity>> onJoined,
    required Option<Unit> onLeave,
  }) = _StreamState;

  factory StreamState.initial() {
    return StreamState(
      joinBroadcast: JoinBroadcastEntity.empty(),
      loading: false,
      onJoined: none(),
      onLeave: none(),
      liveKitError: null,
    );
  }
}

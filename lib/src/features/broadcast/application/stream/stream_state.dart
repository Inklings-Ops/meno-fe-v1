part of "stream_notifier.dart";

@freezed
class StreamState with _$StreamState {
  factory StreamState({
    required JoinBroadcastEntity broadcast,
    required bool loading,
    required bool showError,
    required Option<Either<BroadcastException, JoinBroadcastEntity>> onJoined,
    required Option<Either<BroadcastException, Unit>> onLeave,
  }) = _StreamState;

  factory StreamState.initial() {
    return StreamState(
      broadcast: JoinBroadcastEntity.empty(),
      loading: false,
      showError: false,
      onJoined: none(),
      onLeave: none(),
    );
  }
}

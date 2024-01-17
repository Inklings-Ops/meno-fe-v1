part of 'broadcast_notifier.dart';

@freezed
class BroadcastState with _$BroadcastState {
  const factory BroadcastState({
    required Broadcast broadcast,
    required Status status,
    required bool loading,
    required Option<Either<BroadcastException, Broadcast>> onCreated,
    required Option<Either<BroadcastException, Broadcast>> onStarted,
    required Option<Either<BroadcastException, Unit>> onDeleted,
    required Option<Unit> onEnded,
  }) = _BroadcastState;

  factory BroadcastState.empty() {
    return BroadcastState(
      broadcast: Broadcast.empty(),
      status: Status.offAir,
      loading: false,
      onCreated: none(),
      onStarted: none(),
      onDeleted: none(),
      onEnded: none(),
    );
  }
}

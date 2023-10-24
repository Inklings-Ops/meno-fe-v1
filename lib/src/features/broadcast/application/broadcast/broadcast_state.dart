part of 'broadcast_notifier.dart';

@freezed
class BroadcastState with _$BroadcastState {
  const factory BroadcastState({
    required Broadcast broadcast,
    required Status status,
    required bool isAudioMute,
    required bool loading,
    required bool showError,
    required Option<Either<BroadcastException, Broadcast>> onCreated,
    required Option<Either<BroadcastException, Broadcast>> onStarted,
    required Option<Either<BroadcastException, Unit>> onDeleted,
  }) = _BroadcastState;

  factory BroadcastState.empty() {
    return BroadcastState(
      broadcast: Broadcast.empty(),
      status: Status.offAir,
      isAudioMute: false,
      loading: false,
      showError: false,
      onCreated: none(),
      onStarted: none(),
      onDeleted: none(),
    );
  }
}

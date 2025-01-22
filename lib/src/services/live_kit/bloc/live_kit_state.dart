part of 'live_kit_bloc.dart';

@freezed
class LiveKitState with _$LiveKitState {
  const factory LiveKitState({
    @Default(false) bool micEnabled,
    @Default(LiveKitDisconnected()) LiveKitStatus status,
  }) = _LiveKitState;
}

@freezed
class LiveKitStatus with _$LiveKitStatus {
  const factory LiveKitStatus.disconnected() = LiveKitDisconnected;

  const factory LiveKitStatus.connecting() = LiveKitConnecting;

  const factory LiveKitStatus.broadcastConnected() = LiveKitBroadcastConnected;
  const factory LiveKitStatus.broadcastReconnected() =
      LiveKitBroadcastReconnected;

  const factory LiveKitStatus.streamConnected() = LiveKitStreamConnected;
  const factory LiveKitStatus.streamReconnected() = LiveKitStreamReconnected;

  const factory LiveKitStatus.failed({
    required String error,
    @Default(false) bool isStream,
  }) = LiveKitConnectionFailed;
}

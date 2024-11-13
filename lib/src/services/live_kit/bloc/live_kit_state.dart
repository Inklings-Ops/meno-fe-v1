part of 'live_kit_bloc.dart';

@freezed
class LiveKitState with _$LiveKitState {
  const factory LiveKitState.initial() = LiveKitInitial;
  const factory LiveKitState.loadInProgress() = LiveKitLoadInProgress;
  const factory LiveKitState.broadcastConnected({
    required Room room,
    @Default(true) bool microphoneEnabled,
  }) = LiveKitBroadcastConnected;
  const factory LiveKitState.streamConnected({
    required Room room,
  }) = LiveKitStreamConnected;
  const factory LiveKitState.connectionFailed({
    required String error,
  }) = LiveKitConnectionFailed;
}

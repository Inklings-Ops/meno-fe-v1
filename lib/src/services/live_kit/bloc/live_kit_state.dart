part of 'live_kit_bloc.dart';

@freezed
class LiveKitState with _$LiveKitState {
  const factory LiveKitState.initial() = _Initial;
  const factory LiveKitState.loading() = _Loading;
  const factory LiveKitState.connectFailed(String reason) = _ConnectFailed;
  const factory LiveKitState.connectSuccess({
    required Room room,
    @Default(true) bool isMuted,
  }) = _ConnectSuccess;
}

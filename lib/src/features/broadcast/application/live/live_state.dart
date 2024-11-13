part of 'live_bloc.dart';

@freezed
class LiveState with _$LiveState {
  const factory LiveState.loading() = LiveLoading;

  const factory LiveState.offAir() = OffAir;

  const factory LiveState.live() = Live;

  const factory LiveState.reconnecting() = Reconnecting;

  const factory LiveState.streaming() = Streaming;

  const factory LiveState.failure() = Failure;
}

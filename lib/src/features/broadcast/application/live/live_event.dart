part of 'live_bloc.dart';

@freezed
class LiveEvent with _$LiveEvent {
  const factory LiveEvent.goLoading() = GoLoading;

  const factory LiveEvent.goOffAir() = GoOffAir;

  const factory LiveEvent.goLive() = GoLive;

  const factory LiveEvent.goReconnecting() = GoReconnecting;

  const factory LiveEvent.goStreaming() = GoStreaming;

  const factory LiveEvent.goFailure() = GoFailure;

  const factory LiveEvent.started() = LiveStarted;

  const factory LiveEvent.reset() = LiveReset;
}

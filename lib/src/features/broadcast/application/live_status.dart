import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'live_status.freezed.dart';

@freezed
class LiveStatus with _$LiveStatus {
  const factory LiveStatus.initial() = LiveInitial;
  const factory LiveStatus.loading() = LiveLoadInProgress;
  const factory LiveStatus.started({
    @Default(true) bool microphoneEnabled,
    @Default(false) bool reconnected,
  }) = LiveBroadcastStarted;
  const factory LiveStatus.joined() = LiveBroadcastJoined;
  const factory LiveStatus.broadcastEnded() = LiveBroadcastEnded;
  const factory LiveStatus.streamEnded(
    EndedBroadcastData data,
  ) = LiveStreamEnded;
  const factory LiveStatus.left() = LiveBroadcastLeft;
  const factory LiveStatus.failed(BroadcastException exception) = LiveFailure;
}

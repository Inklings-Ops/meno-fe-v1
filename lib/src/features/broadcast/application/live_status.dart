import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'live_status.freezed.dart';

@freezed
class LiveStatus with _$LiveStatus {
  const factory LiveStatus.initial() = LiveInitial;
  const factory LiveStatus.loading() = LiveLoadInProgress;
  const factory LiveStatus.started({
    @Default(true) bool microphoneEnabled,
  }) = BroadcastStarted;
  const factory LiveStatus.joined() = BroadcastJoined;
  const factory LiveStatus.ended(EndedBroadcastData data) = BroadcastEnded;
  const factory LiveStatus.left() = BroadcastLeft;
  const factory LiveStatus.failed(BroadcastException exception) = BroadcastFailed;
}
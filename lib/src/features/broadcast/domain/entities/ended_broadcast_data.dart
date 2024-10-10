import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'ended_broadcast_data.freezed.dart';

@freezed
class EndedBroadcastData with _$EndedBroadcastData {
  const factory EndedBroadcastData({
    required Broadcast broadcastDetails,
    required BroadcastReason reason,
  }) = _EndedBroadcastData;

  factory EndedBroadcastData.empty() {
    return EndedBroadcastData(
      broadcastDetails: Broadcast.empty(),
      reason: BroadcastReason.empty(),
    );
  }
}

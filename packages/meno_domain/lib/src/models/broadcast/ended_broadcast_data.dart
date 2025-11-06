import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_domain/meno_domain.dart';

part 'ended_broadcast_data.freezed.dart';

part 'ended_broadcast_data.g.dart';

/// Represents the data associated with an ended broadcast.
@freezed
abstract class EndedBroadcastData with _$EndedBroadcastData {
  /// Creates an [EndedBroadcastData] object.
  const factory EndedBroadcastData({
    /// The details of the broadcast that has ended.
    required Broadcast broadcastDetails,

    /// The reason why the broadcast ended.
    required EndedBroadcastReason reason,
  }) = _EndedBroadcastData;

  /// Creates an [EndedBroadcastData] from a JSON object.
  factory EndedBroadcastData.fromJson(Map<String, dynamic> json) =>
      _$EndedBroadcastDataFromJson(json);
}

/// Represents the reason why a broadcast ended.
@freezed
abstract class EndedBroadcastReason with _$EndedBroadcastReason {
  /// Creates an [EndedBroadcastReason] object.
  const factory EndedBroadcastReason({
    /// The type of reason for the broadcast ending.
    required String type,

    /// The message associated with the reason for the broadcast ending.
    required String message,
  }) = _EndedBroadcastReason;

  /// Creates an [EndedBroadcastReason] from a JSON object.
  factory EndedBroadcastReason.fromJson(Map<String, dynamic> json) =>
      _$EndedBroadcastReasonFromJson(json);
}

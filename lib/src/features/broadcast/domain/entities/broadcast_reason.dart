import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_reason.freezed.dart';

@freezed
class BroadcastReason with _$BroadcastReason {
  const factory BroadcastReason({
    required String type,
    required String message,
  }) = _BroadcastReason;

  factory BroadcastReason.empty() {
    return const BroadcastReason(
      type: 'normal',
      message: 'Host has ended the broadcast',
    );
  }
}

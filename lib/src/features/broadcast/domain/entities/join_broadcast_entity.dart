import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_broadcast_entity.freezed.dart';

@freezed
class JoinBroadcastEntity with _$JoinBroadcastEntity {
  factory JoinBroadcastEntity({
    required String broadcastToken,
  }) = _JoinBroadcastEntity;
}

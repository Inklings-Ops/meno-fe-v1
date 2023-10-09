import 'package:freezed_annotation/freezed_annotation.dart';

import 'broadcast.dart';

part 'join_broadcast_entity.freezed.dart';

@freezed
class JoinBroadcastEntity with _$JoinBroadcastEntity {
  factory JoinBroadcastEntity({
    required BroadcastToken broadcastToken,
  }) = _JoinBroadcastEntity;
}

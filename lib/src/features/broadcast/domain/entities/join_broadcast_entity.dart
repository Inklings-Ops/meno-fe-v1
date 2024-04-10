import 'package:freezed_annotation/freezed_annotation.dart';

import 'broadcast.dart';

part 'join_broadcast_entity.freezed.dart';

@freezed
class JoinBroadcastEntity with _$JoinBroadcastEntity {
  factory JoinBroadcastEntity({
    required String broadcastToken,
    required Broadcast broadcast,
  }) = _JoinBroadcastEntity;

  factory JoinBroadcastEntity.empty() {
    return JoinBroadcastEntity(
      broadcastToken: '',
      broadcast: Broadcast.empty(),
    );
  }
}

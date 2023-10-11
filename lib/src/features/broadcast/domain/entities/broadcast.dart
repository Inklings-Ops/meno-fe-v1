import 'package:freezed_annotation/freezed_annotation.dart';

import '../inputs/inputs.dart';
import 'broadcast_creator.dart';
import 'broadcast_status.dart';

part 'broadcast.freezed.dart';

typedef BroadcastId = String;
typedef BroadcastToken = String?;

@freezed
class Broadcast with _$Broadcast {
  factory Broadcast({
    required BroadcastId id,
    required IBroadcastTitle title,
    IBroadcastDescription? description,
    BroadcastToken? broadcastToken,
    BroadcastStatus? status,
    required BroadcastCreator creator,
    String? imageId,
    String? imageUrl,
    String? timeZone,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    dynamic deleted,
  }) = _Broadcast;
}

import 'package:freezed_annotation/freezed_annotation.dart';

import '../inputs/inputs.dart';
import 'broadcast_status.dart';
import 'participant.dart';

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
    String? creatorId,
    Participant? creator,
    String? fullName,
    String? imageId,
    String? imageUrl,
    String? timeZone,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    dynamic deleted,
    int? liveListeners,
    int? totalListeners,
  }) = _Broadcast;

  factory Broadcast.empty() {
    return Broadcast(
      id: '',
      title: IBroadcastTitle(''),
      creator: Participant.empty(),
    );
  }
}

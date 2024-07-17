import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../value_objects/value_objects.dart';
import 'broadcast_status.dart';
import 'participant.dart';

part 'broadcast.freezed.dart';

typedef BroadcastId = String;
typedef BroadcastToken = String?;

@freezed
class Broadcast with _$Broadcast {
  factory Broadcast({
    required Uid<Broadcast> id,
    required SingleLineString title,
    BroadcastDescription? description,
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
      id: Uid<Broadcast>.fromString(''),
      title: SingleLineString(''),
      creator: Participant.empty(),
    );
  }
}

extension BX on Broadcast {
  Option<ValueFailure<dynamic>> get failureOption {
    return title.failureOrUnit
        .andThen(description!.failureOrUnit)
        .fold((f) => some(f), (_) => none());
  }

  bool get isValid => failureOption.isNone();
}

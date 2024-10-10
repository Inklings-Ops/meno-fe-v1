import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'broadcast.freezed.dart';

typedef BroadcastId = String;
typedef BroadcastToken = String?;

@freezed
class Broadcast with _$Broadcast {
  const factory Broadcast({
    required Uid<Broadcast> id,
    required SingleLineString title,
    BroadcastDescription? description,
    BroadcastToken? broadcastToken,
    BroadcastStatus? status,
    String? creatorId,
    BroadcastParticipant? creator,
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
    // For endedBroadcast socket event data
    String? creatorBio,
    String? creatorFullName,
    String? creatorImageUrl,
  }) = _Broadcast;

  factory Broadcast.empty() {
    return Broadcast(
      id: Uid<Broadcast>.fromString(''),
      title: SingleLineString(''),
      creator: BroadcastParticipant.empty(),
    );
  }
}

extension BX on Broadcast {
  Option<ValueFailure<dynamic>> get failureOption {
    return title.failureOrUnit
        .andThen(description!.failureOrUnit)
        .fold(some, (_) => none());
  }

  bool get isValid => failureOption.isNone();
}

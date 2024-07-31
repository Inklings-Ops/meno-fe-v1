import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/entities/entities.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/exceptions/broadcast_exception.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/value_objects/value_objects.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

abstract class IBroadcastFacade {
  Future<Either<BroadcastException, Broadcast>> createBroadcast({
    required SingleLineString title,
    BroadcastDescription? description,
    BroadcastArtwork? artwork,
    String? timeZone,
    List<String>? cohosts,
  });

  Future<Either<BroadcastException, Unit>> deleteBroadcast(Uid<Broadcast> id);

  Future<Either<BroadcastException, Broadcast>> editBroadcast({
    required Uid<Broadcast> id,
    SingleLineString? title,
    BroadcastDescription? description,
    BroadcastArtwork? image,
    String? timeZone,
    DateTime? startTime,
  });

  Future<Either<BroadcastException, JoinBroadcastEntity>> joinBroadcast(
    Uid<Broadcast> id,
  );

  Future<Either<BroadcastException, Broadcast>> startBroadcast(
    Uid<Broadcast> id,
  );

  Future<Either<BroadcastException, BroadcastListEntity>> getBroadcasts({
    /// Status of the broadcast
    /// Example : active or inactive
    String? status,

    /// Adds an extra field to each broadcast response with the number of listeners that tuned in
    /// Example : totalListeners
    String? include,

    /// Returns only broadcasts of accounts the logged In user is subscribed to
    bool? onlySubscriptions,

    /// Searches for broadcasts and creators that match that keyword
    String? keywords,

    /// Return only broadcasts created by a specific user
    String? creatorId,

    /// Sort by a specific broadcast field
    String? sortBy,

    /// Order by a specific broadcast field
    /// Example : ASC or DESC
    String? orderBy,

    /// Used for pagination
    int? page,

    /// Used for pagination
    int? size,

    /// Greater than end time
    String? endTimeGT,

    /// Less than end time
    String? endTimeLT,

    /// Equal to end time
    bool? endTimeExist,

    /// Greater than start time
    String? startTimeGT,

    /// Less than start time
    String? startTimeLT,

    /// Equal to start time
    bool? startTimeExist,
  });
}

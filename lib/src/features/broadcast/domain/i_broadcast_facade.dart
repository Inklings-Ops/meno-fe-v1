import 'package:dartz/dartz.dart';

import 'entities/broadcast_list_entity.dart';
import 'entities/entities.dart';
import 'exceptions/broadcast_exception.dart';
import 'inputs/inputs.dart';

abstract class IBroadcastFacade {
  Future<Either<BroadcastException, Broadcast>> createBroadcast({
    required IBroadcastTitle title,
    IBroadcastDescription? description,
    IBroadcastArtwork? artwork,
    String? timeZone,
    List<String>? cohosts,
  });

  Future<Either<BroadcastException, Unit>> deleteBroadcast({
    required BroadcastId broadcastId,
  });

  Future<Either<BroadcastException, Broadcast>> editBroadcast({
    required BroadcastId broadcastId,
    IBroadcastTitle? title,
    IBroadcastDescription? description,
    IBroadcastArtwork? image,
    String? timeZone,
    DateTime? startTime,
  });

  Future<Either<BroadcastException, JoinBroadcastEntity>> joinBroadcast({
    required BroadcastId broadcastId,
  });

  Future<Either<BroadcastException, Broadcast>> startBroadcast({
    required BroadcastId broadcastId,
  });

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
    String? endTimeEQ,

    /// Greater than start time
    String? startTimeGT,

    /// Less than start time
    String? startTimeLT,

    /// Equal to start time
    String? startTimeEQ,
  });
}

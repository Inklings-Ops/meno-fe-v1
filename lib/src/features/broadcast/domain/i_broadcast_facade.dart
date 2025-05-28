import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meno_fe_v1/src/core/core.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/entities/entities.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

abstract class IBroadcastFacade {
  Future<Either<BroadcastException, Broadcast>> createBroadcast({
    required SingleLineString title,
    required MultiLineString description,
    ImageFile? artwork,
    String? timeZone,
    List<String>? cohosts,
  });

  Future<Either<BroadcastException, Unit>> deleteBroadcast(ID id);

  Future<Either<BroadcastException, Broadcast>> editBroadcast({
    required ID id,
    SingleLineString? title,
    MultiLineString? description,
    ImageFile? image,
    String? timeZone,
    DateTime? startTime,
  });

  Future<Either<BroadcastException, Broadcast>> joinBroadcast(
    ID id,
  );

  Future<Either<BroadcastException, Broadcast>> startBroadcast(
    ID id,
  );

  Future<Either<BroadcastException, PaginatedList<Participant?>>> listeners(
    ID id,
  );

  Future<Either<BroadcastException, List<Participant?>>> liveListeners(
    ID id,
  );

  Future<Either<BroadcastException, PaginatedList<Broadcast?>>> getBroadcasts({
    /// Sort by a specific broadcast field
    required String sortBy,

    /// Order by a specific broadcast field
    /// Example : ASC or DESC
    required OrderBy orderBy,

    /// [ID] of the broadcast
    ID? id,

    /// Status of the broadcast
    /// Example : active or inactive
    String? status,

    /// Adds an extra field to each broadcast response with the number of
    /// listeners that tuned in
    /// Example : totalListeners
    String? include,

    /// Returns only broadcasts of accounts the logged In user is subscribed to
    bool? onlySubscriptions,

    /// Searches for broadcasts and creators that match that keyword
    String? keywords,

    /// Return only broadcasts created by a specific user
    ID? creatorId,

    /// Used for pagination
    int page = 1,

    /// Used for pagination
    int size = 8,

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

    /// To cancel the request
    CancelToken? cancelToken,
  });

  Future<Option<Broadcast>> getSavedBroadcastDetails();

  Future<void> clearSavedBroadcastDetails();

  Future<void> saveBroadcastDetails(Broadcast broadcast);
}

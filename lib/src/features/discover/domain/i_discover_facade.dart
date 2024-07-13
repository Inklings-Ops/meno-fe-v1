import 'package:dartz/dartz.dart';

import 'domain.dart';

abstract class IDiscoverFacade {
  Future<Either<DiscoverException, DiscoverResult>> search({
    String? keywords,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
  });

  Future<Either<DiscoverException, DiscoverResult>> fetchNowLive({
    int? page,
    int? size,
    String? sortBy,
    String? orderBy,
  });

  Future<Either<DiscoverException, DiscoverResult>> fetchRecentlyLive({
    int? page,
    int? size,
    String? sortBy,
    String? orderBy,
    String? endTimeGT,
    String? endTimeLT,
  });

  Future<Either<DiscoverException, DiscoverResult>> fetchBroadcasts({
    String? status,
    String? include,
    bool? onlySubscriptions,
    String? keywords,
    String? creatorId,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
    String? endTime,
    String? endTimeGT,
    String? endTimeLT,
    String? startTime,
    String? startTimeGT,
    String? startTimeLT,
  });
}

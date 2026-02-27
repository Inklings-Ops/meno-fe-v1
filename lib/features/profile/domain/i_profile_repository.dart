import 'package:dio/dio.dart' show CancelToken;
import 'package:fpdart/fpdart.dart' show Either;
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

abstract interface class IProfileRepository {
  Future<Either<MenoException, Profile>> getProfile(Id userId);

  Future<Either<MenoException, PagedList<Profile?>>> getProfiles({
    OrderBy orderBy = OrderBy.asc,
    SortBy sortBy = SortBy.fullName,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool includeSubscribed = true,
    CancelToken? cancelToken,
  });
}

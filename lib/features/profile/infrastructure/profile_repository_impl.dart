import 'package:dio/dio.dart' show CancelToken;
import 'package:fpdart/fpdart.dart' show Either, Left, Right;
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/features/profile/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/broadcast_query.dart';
import 'package:meno/shared/domain/order_by.dart';
import 'package:meno/shared/domain/value_objects/id.dart';
import 'package:meno/shared/domain/value_objects/paged_list.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  const ProfileRepositoryImpl({required ProfileHttpDataSource http})
    : _http = http;

  final ProfileHttpDataSource _http;

  @override
  Future<Either<MenoException, Profile>> getProfile(Id userId) async {
    try {
      final result = await _http.getProfile(userId.getOrCrash());
      if (result == null) return const Left(MenoException('No profile found'));
      return Right(result.toDomain);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, PagedList<Profile?>>> getProfiles({
    OrderBy orderBy = OrderBy.asc,
    SortBy sortBy = SortBy.fullName,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool includeSubscribed = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = <String, dynamic>{};

      data['orderBy'] = orderBy.value;
      data['sortBy'] = sortBy.value;
      data['page'] = pagination.page;
      data['size'] = pagination.size;
      if (keywords != null && keywords.isNotEmpty) data['keywords'] = keywords;
      if (includeSubscribed) data['include'] = 'subscribed';

      final result = await _http.getProfiles(data, cancelToken: cancelToken);

      return Right(
        PagedList(
          items: result.items.map((i) => i?.toDomain).toList(),
          currentPage: result.currentPage,
          totalItems: result.totalItems,
          totalPages: result.totalPages,
        ),
      );
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }
}

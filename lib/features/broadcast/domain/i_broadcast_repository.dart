import 'package:dio/dio.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

abstract class IBroadcastRepository implements Disposable {
  Future<Either<MenoException, Broadcast>> createBroadcast({
    required SingleLineString title,
    required MultiLineString description,
    ImageInput? artwork,
    String? timeZone,
    List<String>? cohosts,
  });

  Future<Either<MenoException, Unit>> deleteBroadcast(Id id);

  Future<Either<MenoException, Broadcast>> editBroadcast({
    required Id id,
    SingleLineString? title,
    MultiLineString? description,
    ImageInput? image,
    String? timeZone,
    DateTime? startTime,
  });

  Future<Either<MenoException, Broadcast>> joinBroadcast(Id id);

  Future<Either<MenoException, Broadcast>> startBroadcast(Id id);

  Future<Either<MenoException, PagedList<Participant?>>> listeners(Id id);

  Future<Either<MenoException, List<Participant?>>> liveListeners(Id id);

  /// Retrieves a paginated list of broadcasts based on the provided query
  /// parameters.
  ///
  /// Returns [PagedList<Broadcast?>] wrapped in Either for error handling.
  /// All filtering, sorting, and pagination options are encapsulated in
  /// [BroadcastQuery].
  Future<Either<MenoException, PagedList<Broadcast?>>> getBroadcasts(
    BroadcastQuery query, {
    CancelToken? cancelToken,
  });

  Future<Option<Broadcast>> getSavedBroadcastDetails();

  Future<void> clearSavedBroadcastDetails();

  Future<void> saveBroadcastDetails(Broadcast broadcast);
}

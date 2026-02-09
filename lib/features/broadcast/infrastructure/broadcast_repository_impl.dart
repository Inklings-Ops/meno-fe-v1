import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/broadcast_query.dart';
import 'package:meno/shared/domain/value_objects/id.dart';
import 'package:meno/shared/domain/value_objects/image_input.dart';
import 'package:meno/shared/domain/value_objects/multi_line_string.dart';
import 'package:meno/shared/domain/value_objects/paged_list.dart';
import 'package:meno/shared/domain/value_objects/single_line_string.dart';

final class BroadcastRepositoryImpl implements IBroadcastRepository {
  BroadcastRepositoryImpl({
    required BroadcastRemoteDataSource remote,
    required BroadcastLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final BroadcastRemoteDataSource _remote;
  final BroadcastLocalDataSource _local;

  final _drafts = ValueNotifier<List<BroadcastDraft?>>([]);

  @override
  Future<Either<MenoException, Broadcast>> createBroadcast({
    required SingleLineString title,
    required MultiLineString description,
    ImageInput? image,
    String? timeZone,
    List<Id>? cohosts,
  }) {
    // TODO: implement createBroadcast
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Unit>> deleteBroadcast(Id id) {
    // TODO: implement deleteBroadcast
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Broadcast>> editBroadcast({
    required Id id,
    SingleLineString? title,
    MultiLineString? description,
    ImageInput? image,
    String? timeZone,
    DateTime? startTime,
  }) {
    // TODO: implement editBroadcast
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, PagedList<Broadcast?>>> getBroadcasts(
    BroadcastQuery query, {
    CancelToken? cancelToken,
  }) async {
    try {
      // Convert query object to API parameters
      final params = _buildQueryParams(query);

      final response = await _remote.getBroadcasts(
        params,
        cancelToken: cancelToken,
      );

      final json = response as Map<String, dynamic>;

      final items = json['broadcasts'] as List<dynamic>;
      final currentPage = json['currentPage'] as int;
      final totalItems = json['totalItems'] as int;
      final totalPages = json['totalPages'] as int;

      final sanitizedResponse = PagedList<Broadcast?>(
        items: items.isNotEmpty
            ? items.map((e) => BroadcastDto.fromJson(e).toDomain).toList()
            : const [],
        currentPage: currentPage,
        totalItems: totalItems,
        totalPages: totalPages,
      );

      return Right(sanitizedResponse);
    } on MenoException catch (exception) {
      return Left(exception);
    } catch (error) {
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Broadcast>> joinBroadcast(Id id) {
    // TODO: implement joinBroadcast
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, PagedList<Participant?>>> listeners(Id id) {
    // TODO: implement listeners
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, List<Participant?>>> liveListeners(Id id) {
    // TODO: implement liveListeners
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, Broadcast>> startBroadcast(Id id) {
    // TODO: implement startBroadcast
    throw UnimplementedError();
  }

  /// Converts the query object to API-compatible parameters
  Map<String, dynamic> _buildQueryParams(BroadcastQuery query) {
    final params = <String, dynamic>{};

    // Pagination
    params['page'] = query.pagination.page;
    params['size'] = query.pagination.size;

    // Sorting
    if (query.sortParams != null) {
      params['sortBy'] = query.sortParams!.sortBy;
      params['orderBy'] = query.sortParams!.orderBy.value;
    }

    // Filters
    if (query.id != null) params['id'] = query.id!.value;
    if (query.status != null) params['status'] = query.status!.value;
    if (query.creatorId != null) params['creatorId'] = query.creatorId!.value;
    if (query.keywords != null) params['keywords'] = query.keywords;
    if (query.onlySubscriptions) params['onlySubscriptions'] = true;

    // Include total listeners
    if (query.includeTotalListeners) params['include'] = 'totalListeners';

    // Time ranges
    if (query.startTimeRange != null) {
      final rng = query.startTimeRange!;
      if (rng.greaterThan != null) params['startTime[gt]'] = rng.greaterThan;
      if (rng.lessThan != null) params['startTime[lt]'] = rng.lessThan;
      if (rng.exists != null) params['startTimeExist'] = rng.exists;
    }

    if (query.endTimeRange != null) {
      final range = query.endTimeRange!;
      if (range.greaterThan != null) params['endTime[gt]'] = range.greaterThan;
      if (range.lessThan != null) params['endTime[lt]'] = range.lessThan;
      if (range.exists != null) params['endTimeExist'] = range.exists;
    }

    return params;
  }

  @override
  Future<void> clearDrafts(Id userId) async {
    await _local.clearDraft(userId.getOrCrash());
    _drafts.value = [];
  }

  @override
  Future<void> deleteDraft({required Id userId, required Id draftId}) async {
    final updatedList = await _local.deleteDraft(
      userId: userId.getOrCrash(),
      draftId: draftId.getOrCrash(),
    );
    _drafts.value = updatedList.map((e) => e?.toDomain).toList();
  }

  @override
  ValueListenable<List<BroadcastDraft?>> get drafts => _drafts;

  @override
  Either<MenoException, List<BroadcastDraft?>> getDrafts(Id userId) {
    try {
      final dtos = _local.getAllDrafts(userId.getOrCrash());
      final transformedList = dtos.map((e) => e?.toDomain).toList();
      _drafts.value = transformedList;
      return Right(transformedList);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<void> saveDraft({
    required Id userId,
    required BroadcastDraft draft,
  }) async {
    try {
      final updatedList = await _local.saveDraft(
        userId: userId.getOrCrash(),
        draft: draft.toDto,
      );
      _drafts.value = updatedList.map((e) => e?.toDomain).toList();
    } catch (error) {
      throw MenoException(error.toString());
    }
  }

  @override
  FutureOr<dynamic> onDispose() {
    _drafts.dispose();
  }

  @override
  Option<BroadcastSession> getActiveBroadcastSession(Id userId) {
    final result = _local.getActiveBroadcastSession(userId.getOrCrash());
    if (result == null) return const None();

    final session = BroadcastSession(
      broadcastId: Id.fromString(result[0]),
      broadcastToken: result[1],
      creatorId: userId,
    );
    return Some(session);
  }

  @override
  Future<void> saveActiveBroadcastSession(BroadcastSession session) async {
    try {
      await _local.saveActiveBroadcastSession(
        userId: session.creatorId.getOrCrash(),
        broadcastId: session.broadcastId.getOrCrash(),
        broadcastToken: session.broadcastToken,
      );
    } catch (error) {
      throw MenoException(error.toString());
    }
  }

  @override
  Future<void> clearActiveBroadcast(Id userId) async {
    try {
      await _local.clearActiveBroadcastId(userId.getOrCrash());
    } catch (error) {
      throw MenoException(error.toString());
    }
  }
}

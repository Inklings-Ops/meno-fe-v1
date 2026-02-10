// ignore_for_file: unnecessary_raw_strings

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
      final response = await _remote.getBroadcasts(
        query.toQueryParameters,
        cancelToken: cancelToken,
      );

      final json = response as Map<String, dynamic>;

      final items = json[r'broadcasts'] as List<dynamic>;
      final currentPage = json[r'currentPage'] as int;
      final totalItems = json[r'totalItems'] as int;
      final totalPages = json[r'totalPages'] as int;

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

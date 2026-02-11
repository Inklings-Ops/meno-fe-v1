// ignore_for_file: unnecessary_raw_strings

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

final class BroadcastRepositoryImpl
    with MenoLogger
    implements IBroadcastRepository {
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
    String? timezone,
    List<Id>? cohosts,
  }) async {
    try {
      final result = await _remote.createBroadcast(
        title: title.getOrCrash(),
        description: description.getOrCrash(),
        image: (image?.getOrNull() as LocalImage?)?.file,
        cohosts: cohosts?.map((e) => e.getOrCrash()).toList(),
        timezone: timezone,
      );
      if (result != null) return Right(result.toDomain);
      return const Left(MenoException('Failed to create broadcast'));
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
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
        query.toApiParams,
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
  Future<Either<MenoException, Broadcast>> startBroadcast(Id id) async {
    try {
      final broadcastId = id.getOrCrash();
      final result = await _remote.startBroadcast(broadcastId);
      if (result != null) return Right(result.toDomain);
      return const Left(MenoException('Failed to start broadcast'));
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
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

    final session = result.toDomain;
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

  // #########################################################################
  // STREAMS
  // #########################################################################
  @override
  Stream<List<Broadcast>> get watchNowLiveBroadcasts {
    late StreamController<List<Broadcast>> controller;
    final currentList = <Broadcast>[];

    // Helper to emit updates easily
    void emit() => controller.add(List.of(currentList));

    // Helper to get the now live broadcasts
    Future<List<Broadcast>> getNowLiveBroadcasts() async {
      final query = BroadcastQuery.nowLive();
      final response = await _remote.getBroadcasts(query.toApiParams);
      final json = response as Map<String, dynamic>;
      final items = json[r'broadcasts'] as List<dynamic>;
      final dtos = items.map(BroadcastDto.fromJson).toList();
      return dtos.map((e) => e.toDomain).toList();
    }

    StreamSubscription? newBroadcastSubscription;
    StreamSubscription? endedBroadcastSubscription;
    StreamSubscription? reconnectionSubscription;

    controller = StreamController<List<Broadcast>>(
      onListen: () async {
        try {
          // Get the initial data using the api client (HTTP)
          final broadcasts = await getNowLiveBroadcasts();
          currentList.addAll(broadcasts);
          emit();
        } catch (e) {
          controller.addError(e);
        }

        // Listen to DTO Streams (Not Socket Events)
        newBroadcastSubscription = _remote.onNewBroadcast.listen((dto) {
          final broadcast = dto.toDomain;
          if (!currentList.any((b) => b.id == broadcast.id)) {
            currentList.insert(0, broadcast);
            emit();
          }
        });

        endedBroadcastSubscription = _remote.onEndedBroadcast.listen((dto) {
          currentList.removeWhere((i) => i.id.getOrCrash() == dto.details.id);
          emit();
        });

        reconnectionSubscription = _remote.onReconnected.listen((_) async {
          try {
            // Silently refresh the list to ensure sync
            final broadcasts = await getNowLiveBroadcasts();
            currentList.clear();
            currentList.addAll(broadcasts);
            emit();
          } catch (_) {
            /* ignore background sync errors */
          }
        });
      },
      onCancel: () {
        newBroadcastSubscription?.cancel();
        endedBroadcastSubscription?.cancel();
        reconnectionSubscription?.cancel();
        controller.close();
      },
    );

    return controller.stream;
  }

  @override
  Stream<EndedBroadcast> get onBroadcastEnded {
    return _remote.onEndedBroadcast.map((e) => e.toDomain);
  }

  @override
  Stream<BroadcastSession?> watchActiveSession(Id userId) async* {
    final dto = _local.watchActiveSession(userId.getOrCrash());
    yield* dto.map((e) => e?.toDomain);
  }
}

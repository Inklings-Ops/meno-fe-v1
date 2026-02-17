// ignore_for_file: unnecessary_raw_strings

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

class BroadcastRepositoryImpl with MenoLogger implements IBroadcastRepository {
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
  Future<Either<MenoException, Broadcast>> getBroadcast(
    Id id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final query = BroadcastQuery(id: id);
      final response = await _remote.getBroadcasts(
        query.toApiParams,
        cancelToken: cancelToken,
      );

      final json = response as Map<String, dynamic>;
      final items = json[r'broadcasts'] as List<dynamic>;

      if (items.isEmpty) return const Left(MenoException('No broadcast found'));
      final dto = BroadcastDto.fromJson(items.first);
      return Right(dto.toDomain);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Broadcast>> joinBroadcast(Id id) {
    // TODO: implement joinBroadcast
    throw UnimplementedError();
  }

  @override
  Future<Either<MenoException, PagedList<Participant?>>> getListeners(Id id) {
    // TODO: implement listeners
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
  Option<BroadcastSession> getActiveBroadcastSession(Id userId) {
    final result = _local.getActiveBroadcastSession(userId.getOrCrash());
    if (result == null) return const None();

    final session = result.toDomain;
    return Some(session);
  }

  @override
  Future<void> saveActiveBroadcastSession(
    Id userId,
    Broadcast broadcast,
  ) async {
    try {
      final session = BroadcastSession.create(broadcast);
      await _local.saveActiveBroadcastSession(
        userId: userId.getOrCrash(),
        session: session.toDto,
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

  @override
  Future<Either<MenoException, Unit>> emitEndBroadcast(Id broadcastId) async {
    try {
      await _remote.emitEndBroadcast(broadcastId.getOrCrash());
      // TODO(gettoknowdavid): Confirm if the local session is cleared elsewhere
      return right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> emitStartedBroadcast(Id id) async {
    try {
      await _remote.emitStartedBroadcast(id.getOrCrash());
      return right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> emitJoinedBroadcast(Id id) async {
    try {
      await _remote.emitJoinedBroadcast(id.getOrCrash());
      return right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> emitLeaveBroadcast(Id broadcastId) async {
    try {
      await _remote.emitLeaveBroadcast(broadcastId.getOrCrash());
      return right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(MenoException(error.toString()));
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

        // Listen to DTO Streams
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
  Stream<List<Participant>> watchLiveParticipants(Id broadcastId) {
    late StreamController<List<Participant>> controller;
    final participants = <String, Participant>{};

    // Helper to emit updates easily
    void emit() => controller.add(participants.values.toList());

    Future<void> initialFetch() async {
      try {
        log.i('BroadcastRepository: Fetching participants for $broadcastId');

        final dtos = await _remote.getLiveListeners(broadcastId.getOrCrash());
        log.i('BroadcastRepository: Received ${dtos.length} participants');

        participants.clear();

        for (final dto in dtos) {
          final participant = dto.toDomain;
          final id = participant.id.getOrCrash();
          participants[id] = participant;
        }

        emit();
        log.d('BroadcastRepository: Got ${participants.length} participants');
      } catch (e, stackTrace) {
        log.e('BroadcastRepository: Failed to fetch participants - $e');
        log.e('Stack trace: $stackTrace');
        controller.addError(e);
      }
    }

    StreamSubscription? newParticipantSub;
    StreamSubscription? participantLeftSub;

    controller = StreamController<List<Participant>>.broadcast(
      onListen: () async {
        log.d('BroadcastRepository: Stream listener attached');

        await initialFetch();

        // Listen to the `newBroadcastListener` Socket event via DTO streams
        newParticipantSub = _remote.onParticipantJoined.listen((dto) {
          participants[dto.id] = dto.toDomain;
          emit();

          log.d(
            'Participant joined: ${dto.fullName} '
            '(total: ${participants.length})',
          );
        });

        participantLeftSub = _remote.onParticipantLeft.listen((dto) {
          final id = dto.id;

          final removedParticipant = participants.remove(id);
          if (removedParticipant != null) {
            emit();
            log.d(
              'Participant left: ${dto.fullName} '
              '(total: ${participants.length})',
            );
          } else {
            log.w(
              'Attempted to remove unknown participant: '
              '${dto.fullName}',
            );
          }
        });
      },
      onCancel: () {
        log.d('BroadcastRepository: Stream listener detached');

        newParticipantSub?.cancel();
        participantLeftSub?.cancel();
        participants.clear();
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
  Stream<BroadcastSession?> watchActiveSession(Id userId) {
    final id = userId.getOrCrash();
    return _local.watchActiveSession(id).map((e) => e?.toDomain);
  }

  @override
  Stream<dynamic> get onHostDisconnected => _remote.onHostDisconnected;

  @override
  Stream<dynamic> get onHostReconnected => _remote.onHostReconnected;

  @override
  Stream<Unit> get onReconnected => _remote.onReconnected.map((_) => unit);

  @override
  Future<void> clearBroadcastSummary(Id userId) async {
    final id = userId.getOrCrash();
    return _local.clearBroadcastSummary(id);
  }

  @override
  Option<BroadcastSummary> getLatestBroadcastSummary(Id userId) {
    final id = userId.getOrCrash();
    final dto = _local.getLatestBroadcastSummary(id);
    if (dto == null) return const None();
    return Some(dto.toDomain);
  }

  @override
  Future<void> saveBroadcastSummary(Id userId, BroadcastSummary summary) async {
    final id = userId.getOrCrash();
    return _local.saveBroadcastSummary(id, summary.toDto);
  }

  @override
  FutureOr<dynamic> onDispose() {
    _drafts.dispose();
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

abstract class IBroadcastRepository implements Disposable {
  ValueListenable<List<BroadcastDraft?>> get drafts;

  Either<MenoException, List<BroadcastDraft?>> getDrafts(Id userId);

  Future<void> saveDraft({required Id userId, required BroadcastDraft draft});

  Future<void> deleteDraft({required Id userId, required Id draftId});

  Future<void> clearDrafts(Id userId);

  Future<Either<MenoException, Broadcast>> createBroadcast({
    required SingleLineString title,
    required MultiLineString description,
    ImageInput? image,
    String? timezone,
    List<Id>? cohosts,
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

  Future<Either<MenoException, PagedList<Participant?>>> getListeners(Id id);

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

  /// Retrieves a single broadcast by its ID.
  ///
  /// Returns [Broadcast] wrapped in Either for error handling.
  /// If the broadcast is not found, returns null.
  Future<Either<MenoException, Broadcast>> getBroadcast(
    Id id, {
    CancelToken? cancelToken,
  });

  Option<BroadcastSession> getActiveBroadcastSession(Id userId);

  Future<void> saveActiveBroadcastSession(Id userId, Broadcast broadcast);

  Future<void> clearActiveBroadcast(Id userId);

  // #########################################################################
  // SOCKET EVENT ACTIONS
  // #########################################################################

  Future<Either<MenoException, Unit>> emitStartedBroadcast(Id id);

  Future<Either<MenoException, Unit>> emitJoinedBroadcast(Id id);

  Future<Either<MenoException, Unit>> emitEndBroadcast(Id broadcastId);

  Future<Either<MenoException, Unit>> emitLeaveBroadcast(Id broadcastId);

  // #########################################################################
  // STREAMS
  // #########################################################################

  Stream<List<Broadcast>> get watchNowLiveBroadcasts;

  Stream<List<Participant>> watchLiveParticipants(Id broadcastId);

  Stream<EndedBroadcast> get onBroadcastEnded;

  Stream<BroadcastSession?> watchActiveSession(Id userId);

  /// Stream of host disconnection events (for listeners)
  Stream<dynamic> get onHostDisconnected;

  /// Stream of host reconnection events (for listeners)
  Stream<dynamic> get onHostReconnected;

  /// Stream for socket reconnection
  Stream<Unit> get onReconnected;
}

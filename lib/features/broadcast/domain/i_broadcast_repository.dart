import 'package:fpdart/fpdart.dart' show Either, Option, Unit;
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/shared.dart';

abstract class IBroadcastRepository implements IBroadcastFeedSource {
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

  Stream<List<Participant>> watchLiveParticipants(Id broadcastId);

  Stream<BroadcastSession?> watchActiveSession(Id userId);

  /// Stream of host disconnection events (for listeners)
  Stream<dynamic> get onHostDisconnected;

  /// Stream of host reconnection events (for listeners)
  Stream<dynamic> get onHostReconnected;

  /// Stream for socket reconnection
  Stream<Unit> get onReconnected;

  /// Save broadcast summary after session ends (before scope destruction)
  Future<void> saveBroadcastSummary(Id userId, BroadcastSummary summary);

  /// Get the latest broadcast summary for ended broadcast page
  Option<BroadcastSummary> getLatestBroadcastSummary(Id userId);

  /// Clear the broadcast summary
  Future<void> clearBroadcastSummary(Id userId);
}

import 'package:dio/dio.dart' show CancelToken;
import 'package:fpdart/fpdart.dart' show Either;
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/broadcast/applications/now_live_broadcasts_manager.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/broadcast/infrastructure/broadcast_repository_impl.dart';
import 'package:meno/features/discover/applications/applications.dart';
import 'package:meno/shared/shared.dart' show BroadcastQuery, Id, PagedList;

/// Narrow feed contract consumed by broadcast list managers.
///
/// One reason to change: the shape of how broadcast feed data is
/// fetched or pushed changes.
///
/// Implemented by [BroadcastRepositoryImpl] — no separate implementation
/// needed. The DI container registers [BroadcastRepositoryImpl] against
/// this interface as an alias of [IBroadcastRepository].
///
/// Consumed by:
///   - [NowLiveBroadcastsManager]   (home page preview strip)
///   - [DiscoverNowLiveManager]     (discover full paginated list)
///   - [DiscoverRecentlyLiveManager]
abstract interface class IBroadcastFeedSource {
  /// Fires each time a new broadcast goes live.
  ///
  /// Managers prepend the incoming broadcast to their local list.
  /// Only relevant to now-live consumers.
  Stream<Broadcast> get onBroadcastStarted;

  /// Fires each time a broadcast ends.
  ///
  /// Now-live managers remove by ID. Recently-live managers prepend.
  Stream<EndedBroadcast> get onBroadcastEnded;

  /// Paginated broadcast list.
  ///
  /// Supports all filtering, sorting, and pagination via [BroadcastQuery].
  /// Used for initial seed fetches and paginating further pages.
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
}

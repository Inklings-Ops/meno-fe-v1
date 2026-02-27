import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:fpdart/fpdart.dart' show Either, Unit;
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

/// Contract for all profile-related data operations.
///
/// Design philosophy (mirrors [IBroadcastRepository]):
/// - Reactive [ValueListenable] fields are the UI's source of truth.
///   Widgets read from these notifiers; they never call getters directly.
/// - `Future<Either<…>>` methods are imperative commands that update the
///   notifiers as a side-effect and return the outcome for error handling.
/// - The domain layer is completely decoupled from HTTP and storage.
abstract interface class IProfileRepository {
  // =========================================================================
  // REACTIVE STATE  (ValueListenable — UI watches these)
  // =========================================================================

  /// The signed-in user's own profile.
  ///
  /// Seeded from the local cache on startup; refreshed from the network
  /// by [fetchMyProfile].
  ValueListenable<Profile?> get myProfile;

  // =========================================================================
  // OWN PROFILE
  // =========================================================================

  /// Hydrates [myProfile] from the local cache immediately, then fires a
  /// network refresh in the background and updates [myProfile] again.
  ///
  /// Call this once when the profile screen mounts.
  Future<Either<MenoException, Profile>> fetchMyProfile(Id userId);

  /// Fetches any user's profile by [userId].
  ///
  /// Does NOT update [myProfile] — use [fetchMyProfile] for the signed-in
  /// user so the notifier stays in sync.
  Future<Either<MenoException, Profile>> getProfile(
    Id userId, {
    CancelToken? cancelToken,
  });

  /// Persists profile edits and refreshes [myProfile] on success.
  Future<Either<MenoException, Profile>> editProfile({
    required Id id,
    SingleLineString? fullName,
    MultiLineString? bio,
    ImageInput? image,
  });

  // =========================================================================
  // BROWSE
  // =========================================================================

  /// Returns a paginated list of all profiles (for search / discovery).
  Future<Either<MenoException, PagedList<Profile?>>> getProfiles({
    OrderBy orderBy = OrderBy.asc,
    SortBy sortBy = SortBy.fullName,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool includeSubscribed = true,
    CancelToken? cancelToken,
  });

  // =========================================================================
  // SUBSCRIBERS / SUBSCRIPTIONS
  // =========================================================================

  /// Returns a paginated list of users subscribed to [subscriptionId].
  Future<Either<MenoException, PagedList<Profile?>>> getSubscribers({
    required Id subscriptionId,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool includeSubscribed = true,
    CancelToken? cancelToken,
  });

  /// Returns a paginated list of users that [subscriberId] follows.
  Future<Either<MenoException, PagedList<Profile?>>> getSubscriptions({
    required Id subscriberId,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool includeSubscribed = true,
    CancelToken? cancelToken,
  });

  /// Subscribes the authenticated user to the profile identified by [id].
  ///
  /// Also optimistically updates `subscribed` on the returned [Profile] if
  /// it is in [myProfile].
  Future<Either<MenoException, Unit>> subscribe(Id id);

  /// Unsubscribes the authenticated user from the profile identified by [id].
  Future<Either<MenoException, Unit>> unsubscribe(Id id);
}

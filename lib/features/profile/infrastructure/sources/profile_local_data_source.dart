import 'dart:convert';

import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';
import 'package:meno/features/profile/infrastructure/infrastructure.dart';

/// Local data source for the profile feature.
///
/// Responsibilities:
/// - Cache the signed-in user's own [ProfileDto] for instant screen render.
///
/// All data is non-sensitive and stored in [LocalStorage] (SharedPreferences).
/// Keys are namespaced per-user so multi-account is handled transparently.
///
/// Design notes:
/// - Reads are synchronous (SharedPreferences has an in-memory mirror).
/// - Writes are `Future<void>` (fire-and-forget at the call-site is fine).
/// - Corrupted JSON is silently dropped and treated as a cache miss — the
///   repository will re-fetch from the network.
///
final class ProfileLocalDataSource {
  const ProfileLocalDataSource(this._storage);

  final LocalStorage _storage;

  // =========================================================================
  // OWN PROFILE CACHE
  // =========================================================================

  /// Returns the cached [ProfileDto] for [userId], or `null` on a miss.
  ProfileDto? getCachedProfile(String userId) {
    final raw = _storage.getString(StorageKeys.profileCache(userId));
    if (raw == null) return null;
    try {
      return ProfileDto.fromJson(jsonDecode(raw));
    } catch (_) {
      // Treat corrupted JSON as a cache miss; let the network fill it.
      return null;
    }
  }

  /// Persists [dto] as the cached profile for [userId].
  ///
  /// Stores only the fields needed for display (via (ProfileDto.stripped)
  /// to keep the payload small.
  Future<void> cacheProfile(String userId, ProfileDto dto) {
    final value = jsonEncode(dto.stripped.toJson());
    return _storage.setString(StorageKeys.profileCache(userId), value);
  }

  /// Removes the cached profile for [userId] (e.g. on logout).
  Future<void> clearProfile(String userId) {
    return _storage.remove(StorageKeys.profileCache(userId));
  }

  // =========================================================================
  // BULK CLEAR  (logout / account removal)
  // =========================================================================

  /// Clears all profile-related local data for [userId].
  ///
  /// Call this on logout or when the account is removed so stale data
  /// cannot bleed into a subsequent session.
  Future<void> clearAll(String userId) {
    return Future.wait([clearProfile(userId)]);
  }

  // =========================================================================
  // HELPERS
  // =========================================================================

  List<BroadcastDto> _decodeBroadcastList(String? raw) {
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map(BroadcastDto.fromJson).toList();
    } catch (_) {
      return const [];
    }
  }
}

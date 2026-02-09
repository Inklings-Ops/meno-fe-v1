import 'dart:convert';

import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';

class BroadcastLocalDataSource {
  const BroadcastLocalDataSource(this._storage);

  final LocalStorage _storage;

  // ======================================================================
  // CRASH RECOVERY
  // ======================================================================

  /// Saves the active broadcast ID specifically for THIS user.
  Future<void> saveActiveBroadcastSession({
    required String userId,
    required String broadcastId,
  }) async {
    final key = StorageKeys.activeBroadcast(userId);
    await _storage.setString(key, broadcastId);
  }

  /// Retrieves the ID if the app was killed mid-broadcast.
  Future<String?> getActiveBroadcastSession(String userId) async {
    final key = StorageKeys.activeBroadcast(userId);
    return _storage.getString(key);
  }

  /// Clears the ID when the user taps "End Broadcast" gracefully.
  Future<void> clearActiveBroadcastId(String userId) async {
    final key = StorageKeys.activeBroadcast(userId);
    await _storage.remove(key);
  }

  // ======================================================================
  // BROADCAST DRAFTS
  // ======================================================================

  /// Saves the form data (Title, Desc, Tags) so the user can come back later.
  Future<void> saveDraft({
    required String userId,
    required BroadcastDraftDto draft,
  }) async {
    final key = StorageKeys.broadcastDraft(userId);
    final jsonString = jsonEncode(draft.toJson());
    await _storage.setString(key, jsonString);
  }

  BroadcastDraftDto? getDraft(String userId) {
    final key = StorageKeys.broadcastDraft(userId);
    final jsonString = _storage.getString(key);
    if (jsonString == null) return null;
    return BroadcastDraftDto.fromJson(jsonDecode(jsonString));
  }

  Future<void> clearDraft(String userId) async {
    final key = StorageKeys.broadcastDraft(userId);
    await _storage.remove(key);
  }

  // ======================================================================
  // BROADCAST CACHE
  // ======================================================================

  /// Caches the list of past broadcasts for offline viewing.
  Future<void> cacheRecentBroadcasts(List<BroadcastDto> list) async {}

  /// Retrieves the cached list of past broadcasts.
  Future<List<BroadcastDto>> getCachedBroadcasts() async {
    return [];
  }
}

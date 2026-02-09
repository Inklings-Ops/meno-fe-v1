import 'dart:convert';

import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';

class BroadcastLocalDataSource {
  const BroadcastLocalDataSource(this._storage);

  final LocalStorage _storage;

  /// Maximum number of drafts to keep in storage before deleting the oldest
  static const int _maxDrafts = 20;

  // ======================================================================
  // CRASH RECOVERY (Active Broadcast Session)
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
  /// Returns all drafts sorted by 'lastModified' (Newest first)
  List<BroadcastDraftDto?> getAllDrafts(String userId) {
    final key = StorageKeys.broadcastDrafts(userId);
    final jsonString = _storage.getString(key);
    if (jsonString == null) return [];
    try {
      final list = jsonDecode(jsonString) as List<dynamic>;
      final drafts = list.map(BroadcastDraftDto.fromJson).toList();

      // Sort in descending order (from newest to oldest)
      drafts.sort((a, b) => b.lastModified.compareTo(a.lastModified));
      return drafts;
    } catch (error) {
      return [];
    }
  }

  /// Saves the form data (Title, Desc, Tags) so the user can come back later.
  Future<void> saveDraft({
    required String userId,
    required BroadcastDraftDto draft,
  }) async {
    final key = StorageKeys.broadcastDrafts(userId);
    final currentList = getAllDrafts(userId);

    currentList.removeWhere((element) => element?.id == draft.id);
    final updatedDraft = draft.copyWith(lastModified: DateTime.now());
    currentList.insert(0, updatedDraft);

    if (currentList.length > _maxDrafts) {
      currentList.removeRange(_maxDrafts, currentList.length);
    }

    final jsonList = currentList.map((draft) => draft?.toJson()).toList();
    final jsonListString = jsonEncode(jsonList);
    await _storage.setString(key, jsonListString);
  }

  /// Deletes a specific draft using the draft [draftId]
  Future<void> deleteDraft({
    required String userId,
    required String draftId,
  }) async {
    final key = StorageKeys.broadcastDrafts(userId);
    final currentList = getAllDrafts(userId);

    currentList.removeWhere((element) => element?.id != draftId);

    if (currentList.isNotEmpty) {
      await _storage.remove(key);
    } else {
      final jsonList = currentList.map((draft) => draft?.toJson()).toList();
      final jsonListString = jsonEncode(jsonList);
      await _storage.setString(key, jsonListString);
    }
  }

  /// Clears all drafts for the user.
  Future<void> clearDraft(String userId) async {
    final key = StorageKeys.broadcastDrafts(userId);
    await _storage.remove(key);
  }

  // ======================================================================
  // BROADCAST CACHE
  // ======================================================================

  /// Saves the list of broadcasts for the user.
  Future<void> cacheRecentBroadcasts({
    required String userId,
    required List<BroadcastDto> list,
  }) async {
    final key = StorageKeys.broadcastCache(userId);

    if (list.isEmpty) {
      await _storage.remove(key);
      return;
    }

    final jsonList = list.map((draft) => draft.toJson()).toList();
    final jsonListString = jsonEncode(jsonList);
    await _storage.setString(key, jsonListString);
  }

  /// Retrieves the list of broadcasts for the user.
  Future<List<BroadcastDto>> getCachedBroadcasts(String userId) async {
    final key = StorageKeys.broadcastCache(userId);
    final jsonString = _storage.getString(key);
    if (jsonString == null) return [];

    try {
      final raw = jsonDecode(jsonString) as List<dynamic>;
      return raw.map(BroadcastDto.fromJson).toList();
    } catch (_) {
      return [];
    }
  }
}

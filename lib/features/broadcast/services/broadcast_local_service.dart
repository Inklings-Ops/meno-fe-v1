import 'dart:convert';

import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/services/local_storage.dart';
import 'package:meno/features/broadcast/model/model.dart';

final class BroadcastLocalService {
  const BroadcastLocalService(this._storage);

  final LocalStorage _storage;

  /// Maximum number of drafts to keep in storage before deleting the oldest
  static const int _maxDrafts = 20;

  // ======================================================================
  // CRASH RECOVERY (Active Broadcast Session)
  // ======================================================================

  /// Saves the active broadcast ID specifically for THIS user.
  /// Saves a [BroadcastSessionDto] class/object.
  Future<void> saveActiveBroadcastSession({
    required Id userId,
    required BroadcastSession session,
  }) async {
    final key = StorageKeys.activeBroadcast(userId.getOrCrash());
    await _storage.setString(key, jsonEncode(session.toDto.toJson()));
  }

  /// Retrieves the ID if the app was killed mid-broadcast.
  /// Returns a [List] of the broadcast ID and the broadcast token.
  BroadcastSession? getActiveBroadcastSession(Id userId) {
    final key = StorageKeys.activeBroadcast(userId.getOrCrash());
    final jsonString = _storage.getString(key);
    if (jsonString == null) return null;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return BroadcastSessionDto.fromJson(json).toDomain;
  }

  /// Clears the ID when the user taps "End Broadcast" gracefully.
  Future<void> clearActiveBroadcastId(Id userId) async {
    final key = StorageKeys.activeBroadcast(userId.getOrCrash());
    await _storage.remove(key);
  }

  // ======================================================================
  // BROADCAST DRAFTS
  // ======================================================================
  /// Returns all drafts sorted by 'lastModified' (Newest first)
  List<BroadcastDraft?> getAllDrafts(Id userId) {
    final key = StorageKeys.broadcastDrafts(userId.getOrCrash());
    final jsonString = _storage.getString(key);
    if (jsonString == null) return [];
    try {
      final list = jsonDecode(jsonString) as List<dynamic>;
      final drafts = list
          .map((e) => BroadcastDraftDto.fromJson(e).toDomain)
          .toList();

      // Sort in descending order (from newest to oldest)
      drafts.sort((a, b) => b.lastModified.compareTo(a.lastModified));
      return drafts;
    } catch (error) {
      return [];
    }
  }

  /// Saves the form data (Title, Desc, Tags) so the user can come back later.
  /// Returns the updated list of drafts
  Future<List<BroadcastDraft?>> saveDraft({
    required Id userId,
    required BroadcastDraft draft,
  }) async {
    final key = StorageKeys.broadcastDrafts(userId.getOrCrash());
    final currentList = getAllDrafts(userId);

    currentList.removeWhere((element) => element?.id == draft.id);
    final updatedDraft = draft.copyWith(lastModified: DateTime.now());
    currentList.insert(0, updatedDraft);

    if (currentList.length > _maxDrafts) {
      currentList.removeRange(_maxDrafts, currentList.length);
    }

    final jsonList = currentList.map((draft) => draft?.toDto.toJson()).toList();
    final jsonListString = jsonEncode(jsonList);
    await _storage.setString(key, jsonListString);

    return currentList;
  }

  /// Deletes a specific draft using the draft [draftId]
  /// Returns the updated list of drafts
  Future<List<BroadcastDraft?>> deleteDraft({
    required Id userId,
    required Id draftId,
  }) async {
    final key = StorageKeys.broadcastDrafts(userId.getOrCrash());
    final currentList = getAllDrafts(userId);

    currentList.removeWhere((element) => element?.id == draftId);

    if (currentList.isNotEmpty) {
      await _storage.remove(key);
    } else {
      final list = currentList.map((draft) => draft?.toDto.toJson()).toList();
      final jsonListString = jsonEncode(list);
      await _storage.setString(key, jsonListString);
    }

    return currentList;
  }

  /// Clears all drafts for the user.
  Future<void> clearDraft(Id userId) async {
    final key = StorageKeys.broadcastDrafts(userId.getOrCrash());
    await _storage.remove(key);
  }

  // ======================================================================
  // BROADCAST CACHE
  // ======================================================================

  /// Saves the list of broadcasts for the user.
  Future<void> cacheRecentBroadcasts({
    required Id userId,
    required List<Broadcast> list,
  }) async {
    final key = StorageKeys.broadcastCache(userId.getOrCrash());

    if (list.isEmpty) {
      await _storage.remove(key);
      return;
    }

    final jsonList = list.map((draft) => draft.toDto.toJson()).toList();
    final jsonListString = jsonEncode(jsonList);
    await _storage.setString(key, jsonListString);
  }

  /// Retrieves the list of broadcasts for the user.
  Future<List<Broadcast>> getCachedBroadcasts(Id userId) async {
    final key = StorageKeys.broadcastCache(userId.getOrCrash());
    final jsonString = _storage.getString(key);
    if (jsonString == null) return [];

    try {
      final raw = jsonDecode(jsonString) as List<dynamic>;
      return raw.map((e) => BroadcastDto.fromJson(e).toDomain).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveBroadcastSummary(Id userId, BroadcastSummary summary) async {
    final key = StorageKeys.broadcastSummary(userId.getOrCrash());
    final jsonString = jsonEncode(summary.toDto.toJson());
    await _storage.setString(key, jsonString);
  }

  BroadcastSummary? getLatestBroadcastSummary(Id userId) {
    final key = StorageKeys.broadcastSummary(userId.getOrCrash());
    final jsonString = _storage.getString(key);
    if (jsonString == null) return null;
    return BroadcastSummaryDto.fromJson(jsonDecode(jsonString)).toDomain;
  }

  Future<void> clearBroadcastSummary(Id userId) {
    final key = StorageKeys.broadcastSummary(userId.getOrCrash());
    return _storage.remove(key);
  }

  // #######################################################################
  // STREAMS
  // #######################################################################
  /// Watches the active session.
  ///
  /// Because LocalStorage.watchKey emits the current value immediately
  /// (if using startWith) or we can manually yield it, this stream is always
  /// up to date.
  Stream<BroadcastSession?> watchActiveSession(Id userId) {
    final key = StorageKeys.activeBroadcast(userId.getOrCrash());

    return _storage.watchKey(key).map((jsonString) {
      if (jsonString == null) return null;
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return BroadcastSessionDto.fromJson(json).toDomain;
      } catch (_) {
        return null;
      }
    });
  }
}

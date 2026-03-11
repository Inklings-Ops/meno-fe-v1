import 'package:meno/_core/keys/storage_keys.dart';
import 'package:meno/_shared/services/local_storage.dart';

/// Discover's local data source.
///
/// Owns only what discover uniquely needs to persist: recent search history.
/// Does NOT cache broadcast/profile results — those are the broadcast
/// repository's concern.
class DiscoverLocalService {
  const DiscoverLocalService(this._storage);

  final LocalStorage _storage;

  static const int _maxRecentSearches = 10;

  // ========================================================================
  // RECENT SEARCHES
  // ========================================================================
  /// Returns the list of recent search terms for [userId], most recent first.
  List<String> getRecentSearches(String userId) {
    final key = StorageKeys.recentSearches(userId);
    return _storage.getList(key) ?? [];
  }

  /// Adds [term] to the top of the recent searches list for [userId].
  /// Deduplicates and caps at [_maxRecentSearches].
  Future<void> addRecentSearch(String userId, String term) async {
    if (term.trim().isEmpty) return;

    final key = StorageKeys.recentSearches(userId);
    final current = getRecentSearches(userId);

    // Deduplicate (case-insensitive), then prepend
    current.removeWhere((s) => s.toLowerCase() == term.toLowerCase());
    current.insert(0, term);

    if (current.length > _maxRecentSearches) {
      current.removeRange(_maxRecentSearches, current.length);
    }

    await _storage.setList(key, current);
  }

  /// Removes a single [term] from recent searches for [userId].
  Future<void> removeRecentSearch(String userId, String term) async {
    final key = StorageKeys.recentSearches(userId);
    final current = getRecentSearches(userId);
    current.removeWhere((s) => s == term);
    await _storage.setList(key, current);
  }

  /// Clears all recent searches for [userId].
  Future<void> clearRecentSearches(String userId) {
    final key = StorageKeys.recentSearches(userId);
    return _storage.remove(key);
  }

  /// Reactive stream of recent searches for [userId].
  /// Emits immediately with current value, then on every update.
  Stream<List<String>> watchRecentSearches(String userId) {
    final key = StorageKeys.recentSearches(userId);
    return _storage.watchKey(key).map((_) => getRecentSearches(userId));
  }
}

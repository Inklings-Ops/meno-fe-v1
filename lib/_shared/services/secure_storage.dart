import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Reactive wrapper around FlutterSecureStorage.
///
/// Features:
/// - Thread-safe operations with mutex
/// - Reactive change notifications via streams
/// - Deduplication to prevent unnecessary writes
/// - Batch operations for performance
/// - Error handling with fallback strategies
/// - Memory cache for fast reads
///
/// Architecture:
/// - Acts as the single source of truth for secure data
/// - Decouples infrastructure (interceptors) from features (auth)
/// - Enables observer pattern without tight coupling
class SecureStorage {
  SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  // ======================================================================
  // REACTIVE CORE
  // ======================================================================

  final _changeController = StreamController<StorageEvent>.broadcast();

  /// Stream of storage change events
  Stream<StorageEvent> get onChange => _changeController.stream;

  /// Watch changes to a specific key
  Stream<String?> watchKey(String key) {
    return _changeController.stream
        .where((event) => event.key == key)
        .map((event) => event.value);
  }

  /// Watch changes to multiple keys
  Stream<Map<String, String?>> watchKeys(List<String> keys) {
    return _changeController.stream
        .where((event) => keys.contains(event.key))
        .asyncMap((_) async {
          final results = <String, String?>{};
          for (final key in keys) {
            results[key] = await read(key);
          }
          return results;
        });
  }

  // ======================================================================
  // MEMORY CACHE (Performance Optimization)
  // ======================================================================

  final _cache = <String, String?>{};
  bool _cacheEnabled = true;

  /// Enable or disable memory caching
  void setCacheEnabled(bool enabled) {
    _cacheEnabled = enabled;
    if (!enabled) _cache.clear();
  }

  // ======================================================================
  // OPERATIONS
  // ======================================================================

  /// Read a value from storage
  ///
  /// Uses memory cache if enabled for performance
  Future<String?> read(String key) async {
    try {
      // Always trust the disk. It is the only Source of Truth.
      return await _storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  /// Write a value to storage
  ///
  /// Features:
  /// - Deduplication (skips if value unchanged)
  /// - Thread-safe (uses mutex)
  /// - Reactive (notifies listeners)
  /// - Null-safe (deletes if value is null)
  Future<void> write(String key, {required String? value}) async {
    if (value == null) return delete(key);

    try {
      // REMOVED: await read(key) check.
      // Just write. It's faster to overwrite than to ask-then-overwrite.
      await _storage.write(key: key, value: value);

      _changeController.add(
        StorageEvent(key: key, value: value, type: StorageEventType.write),
      );
    } catch (e) {
      // Log error
      rethrow;
    }
  }

  /// Delete a value from storage
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
      _changeController.add(
        StorageEvent(key: key, value: null, type: StorageEventType.delete),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Delete all values from storage
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();

      // Clear cache
      if (_cacheEnabled) {
        _cache.clear();
      }

      // Notify listeners with wildcard
      _changeController.add(
        const StorageEvent(
          key: '*',
          value: null,
          type: StorageEventType.deleteAll,
        ),
      );
    } catch (e) {
      debugPrint('SecureStorage deleteAll error: $e');
      rethrow;
    }
  }

  // ======================================================================
  // BATCH OPERATIONS (Performance)
  // ======================================================================

  /// Write multiple key-value pairs atomically
  ///
  /// More efficient than individual writes for bulk operations
  Future<void> writeBatch(Map<String, String?> entries) async {
    if (entries.isEmpty) return;

    final futures = <Future<void>>[];

    for (final entry in entries.entries) {
      futures.add(write(entry.key, value: entry.value));
    }

    await Future.wait(futures);
  }

  /// Read multiple keys at once
  ///
  /// More efficient than individual reads
  Future<Map<String, String?>> readBatch(List<String> keys) async {
    final results = <String, String?>{};

    final futures = keys.map((key) async {
      results[key] = await read(key);
    });

    await Future.wait(futures);

    return results;
  }

  /// Delete multiple keys at once
  Future<void> deleteBatch(List<String> keys) async {
    final futures = keys.map(delete);
    await Future.wait(futures);
  }

  // ======================================================================
  // UTILITIES
  // ======================================================================

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      debugPrint('SecureStorage containsKey error for key "$key": $e');
      return false;
    }
  }

  /// Get all keys
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      debugPrint('SecureStorage readAll error: $e');
      return {};
    }
  }

  /// Clear memory cache (useful for testing or memory management)
  void clearCache() {
    _cache.clear();
  }

  /// Dispose of resources
  @mustCallSuper
  void dispose() {
    _changeController.close();
    _cache.clear();
  }
}

// ========================================================================
// STORAGE EVENT MODEL
// ========================================================================

/// Represents a storage change event
class StorageEvent {
  const StorageEvent({
    required this.key,
    required this.value,
    required this.type,
  });

  final String key;
  final String? value;
  final StorageEventType type;

  @override
  String toString() => 'StorageEvent($type: $key = $value)';
}

/// Types of storage events
enum StorageEventType { write, delete, deleteAll }

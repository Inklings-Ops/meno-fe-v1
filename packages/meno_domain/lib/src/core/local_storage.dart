/// Defines the abstract interface for a key-value storage service.
///
/// This contract provides a unified API to interact with both persistent,
/// non-secure storage (like SharedPreferences) and encrypted, secure storage
/// (like FlutterSecureStorage). By depending on this abstraction, other
/// parts of the application remain decoupled from the concrete implementation
/// details of the storage plugins.
abstract class LocalStorage {
  /// Writes a string [value] to storage, associated with a [key].
  ///
  /// The [secure] flag determines the storage location:
  /// - If `false` (default), saves to non-secure `SharedPreferences`.
  /// - If `true`, saves to encrypted `FlutterSecureStorage`.
  Future<void> write(String key, {required String value, bool secure = false});

  /// Asynchronously reads a string value from secure storage associated with
  /// [key].
  ///
  /// This method is for retrieving values specifically from
  /// `FlutterSecureStorage`. Returns `null` if the key is not found.
  Future<String?> readAsync(String key);

  /// Synchronously reads a value from non-secure storage associated with [key].
  ///
  /// This method retrieves values specifically from `SharedPreferences`.
  /// It returns the value as an [Object?] and the caller is responsible for
  /// casting it to the expected type (e.g., `bool`, `String`, `int`).
  /// Returns `null` if the key is not found.
  Object? read(String key);

  /// Deletes a value from storage associated with [key].
  ///
  /// The [secure] flag determines which storage to delete from.
  Future<void> delete(String key, {bool secure = false});

  /// Asynchronously checks if a [key] exists in secure storage.
  ///
  /// This method is for checking keys specifically in `FlutterSecureStorage`.
  Future<bool> hasKeyAsync(String key);

  /// Synchronously checks if a [key] exists in non-secure storage.
  ///
  /// This method is for checking keys specifically in `SharedPreferences`.
  bool hasKey(String key);

  /// Deletes all keys and values from the specified storage.
  ///
  /// The [secure] flag determines which storage to clear.
  Future<void> deleteAll({bool secure = false});
}

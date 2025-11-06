// Ignore adding documentation for each route
// ignore_for_file: public_member_api_docs

/// A utility class that holds constant string values for route paths.
///
/// This class is designed to prevent typos by providing a single source of
/// truth for route names throughout the application. It cannot be instantiated
/// or extended.
///
final class MRoutes {
  const MRoutes._();

  /// A private helper function to construct a URL path with optional query
  /// parameters.
  ///
  /// Takes a base [path] and a map of [queryParams]. It filters out any
  /// null or empty query parameters before building the final URI string.
  static String _buildPath(String path, Map<String, dynamic>? queryParams) {
    // Early exit if there are no query parameters to process.
    // This is a quick performance optimization.
    if (queryParams == null || queryParams.isEmpty) return path;

    // Filter the query parameters to create a clean, effective map.
    // This step is crucial to avoid adding empty parameters to the URL
    // (e.g., "path?name=" instead of just "path").
    final effectiveParams = Map<String, String>.fromEntries(
      queryParams.entries
          // Keep only entries where the value is not null and its string
          // representation is not empty. This handles cases like
          // `{'id': null}` or `{'name': ''}`.
          .where((e) => e.value != null && e.value.toString().isNotEmpty)
          // Convert all values to their string representation to ensure
          // they are valid for a URL. The resulting map is of type
          // `Map<String, String>`.
          .map((e) => MapEntry(e.key, e.value.toString())),
    );

    // If, after filtering, there are no valid parameters left,
    // just return the original base path.
    if (effectiveParams.isEmpty) return path;

    // Use the `Uri` class to safely build the final URL.
    // This correctly handles URL encoding for parameter keys and values,
    // preventing issues with special characters.
    return Uri(path: path, queryParameters: effectiveParams).toString();
  }

  // --- AUTH & ONBOARDING ---
  static const String root_ = 'root';
  static const String root = '/';

  static const String onboarding_ = 'onboarding';
  static const String onboarding = '/onboarding';

  static const String login_ = 'login';
  static const String loginPath = '/login';

  static String login({bool? implyLeading, bool? isPasswordOnly}) {
    return _buildPath(loginPath, {
      'implyLeading': implyLeading,
      'isPasswordOnly': isPasswordOnly,
    });
  }

  static const String register_ = 'register';
  static const String registerPath = '/register';

  static String register({bool? implyLeading}) {
    return _buildPath(registerPath, {
      'implyLeading': implyLeading,
    });
  }

  static const String emailVerification_ = 'emailVerification';
  static const String emailVerification = '/email-verification';

  // ... (All your other main page routes like home, discover, etc. go here) ...

  // --- BROADCAST ---

  static const String broadcast_ = 'broadcastDetails';
  static const String broadcastPath = '/broadcasts/:id';

  static String broadcast({required String id}) => '/broadcasts/$id';

  // ... other broadcast routes ...

  // --- SETTINGS ---

  static const String settings_ = 'settings';
  static const String settings = '/settings';

  // ... other settings routes ...

  // --- MODALS & DIALOGS (WEB REFACTOR) ---

  // 1. PAGE MODALS (GOOD routes):
  // These are fine as routes because they are full-screen or
  // destinations in themselves.
  static const String preStreamModal_ = 'preStreamModal';
  static const String preStreamModal = '/pre-stream-modal';

  static const String folderFormModal_ = 'folderFormModal';
  static const String folderFormModal = '/create-new-folder-modal';

  static const String editProfileModal_ = 'editProfileModal';
  static const String editProfileModal = '/edit-profile-modal';

  static const String switchAccountModal_ = 'switchAccountModal';
  static const String switchAccountModal = '/switch-account-modal';

  static const String pickImageModal_ = 'pickImageModal';
  static const String pickImageModal = '/pick-image-modal';

  // 2. SIMPLE DIALOGS (BAD routes):
  // These should NOT be routes. They are actions taken on another screen.
  // You should create helper functions in your feature packages for these,
  // for example:
  //
  // Future<void> showDeleteNoteDialog(BuildContext context, String noteId) {
  //   return showDialog(context: context, builder: ...);
  // }
  //
  // REMOVED: /delete-note-dialog
  // REMOVED: /delete-folder-dialog
  // REMOVED: /remove-note-folder-dialog
  // REMOVED: /logout-confirmation-dialog
  // REMOVED: /note-card-options-modal (This is a BottomSheet, not a page)
  // REMOVED: /add-note-to-folder-modal (Also sounds like a BottomSheet)
}

abstract class StorageKeys {
  const StorageKeys._();

  // Complete credential (for repository/UI)
  static const credential = 'current_user_credential';

  // Individual fields (for fast interceptor access)
  static const userId = 'current_user_id';
  static const accessToken = 'current_user_token';
  static const refreshToken = 'current_refresh_token';
  static const sessionExpiry = 'session_expiry';

  // Multi-account support
  static const accounts = 'all_accounts';

  // #######################################################################
  // BROADCAST KEYS
  // #######################################################################

  static String activeBroadcast(String userId) => 'broadcast_session_$userId';

  static String broadcastDrafts(String userId) => 'broadcast_draft_$userId';

  static String broadcastCache(String userId) => 'broadcast_cache_$userId';

  static String broadcastSummary(String userId) => 'broadcast_summary_$userId';

  static String recentSearches(String userId) => 'recent_search_$userId';

  // #######################################################################
  // PROFILE KEYS
  // #######################################################################

  static String profileCache(String userId) => 'profile_cache_$userId';

  static String profileFavorites(String userId) => 'profile_favorites_$userId';

  static String profileRecordings(String userId) => 'profile_recording_$userId';

  // #######################################################################
  // SETTINGS KEYS
  // #######################################################################

  static String userSettingsCache(String userId) => 'user_settings_$userId';
}

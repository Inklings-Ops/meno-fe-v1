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
  // #  BROADCAST KEYS
  // #######################################################################

  static String activeBroadcast(String userId) => 'broadcast_session_$userId';

  static String broadcastDrafts(String userId) => 'broadcast_draft_$userId';

  static String broadcastCache(String userId) => 'broadcast_cache_$userId';
}

class R {
  const R._();

  static const List<String> publicRoutes = [
    R.login,
    R.onboarding,
    R.register,
    R.resetPassword,
  ];

  static const String loading = '/loading';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String partialLogin = '/login?isPasswordOnly=true';
  static const String loginWithLeading = '/login?implyLeading=true';
  static const String register = '/register';
  static const String registerWithLeading = '/register?implyLeading=true';
  static const String registerWithoutLeading = '/register?implyLeading=false';
  static const String emailVerification = '/emailVerification';
  static const String resetPassword = '/resetPassword';
  static const String resetPwdOtp = '/resetPasswordOtp';
  static const String resetPwdSuccess = '/resetPasswordSuccess';
  static const String createNewPassword = '/createNewPassword';
  static const String webCreateBroadcast = '/web-createBroadcast';
  static const String broadcastEditor = '/broadcast-editor';
  static const String home = '/';
  static const String discover = '/discover';
  static const String myProfile = '/my-profile';
  static const String nowLive = '/nowLive';
  static const String recentlyLive = '/recentlyLive';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String notificationSettings = '/settings/notifications';
  static const String securitySettings = '/settings/security';
  static const String about = '/settings/about';
  static const String endedBroadcast = '/endedBroadcast';
  static const String biblePage = '/bible-page';

  static const String liveSessionInitialization = '/live-initialization';
  static const String liveBroadcast = '/live-broadcast';
  static const String liveChat = '/live-chat';
  static const String liveBible = '/live-bible';
  static const String liveNotes = '/live-notes';
  static const String liveFolders = '/live-folders';

  static String liveNoteEditor([String id = 'new']) => '$liveNotes/$id';

  static String liveFolder(String id) => '$liveFolders/$id';
  static const String notesTabEditorFull = '/notes-tab/notes-tab-editor';

  static const String notes = '/notes';

  static String noteEditor([String id = 'new']) => '$notes/$id';

  static const String folders = '/folders';

  static String folder(String id) => '$folders/$id';

  static const String broadcasts = '/broadcasts';

  static String broadcast(String id) => '$broadcasts/$id';

  static String preStream(String broadcastId) => '/pre-stream/$broadcastId';

  static const String profiles = '/users/profiles';

  static String profile(String userId) => '/users/$userId/profile';

  static String switchAccount(String userId) => '/switch-account/$userId';

  static const String discoverSearch = '/discover-search';
  static const String discoverAllTab = '/discover-all';
  static const String discoverNowLiveTab = '/discover-now-live';
  static const String discoverRecentlyLiveTab = '/discover-recently-live';
  static const String discoverSuggestedAccountsLiveTab = '/discover-accounts';

  static const String userProfileRecentTab = '/user-profile-recent-tab';
  static const String userProfileAllTab = '/user-profile-all-tab';
  static const String userProfileFavouritesTab = '/user-profile-favourite-tab';
}

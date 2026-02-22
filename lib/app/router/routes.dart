class R {
  const R._();

  static const List<String> publicRoutes = [
    R.loading,
    R.login,
    R.onboarding,
    R.register,
    R.resetPassword,
  ];

  static const String root = '/';
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
  static const String createBroadcast = '/createBroadcast';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String notes = '/notes';
  static const String myProfile = '/my-profile';
  static const String othersProfile = '/others-profile';
  static const String nowLive = '/nowLive';
  static const String recentlyLive = '/recentlyLive';
  static const String notifications = '/notifications';
  static const String folder = '/folder';
  static const String settings = '/settings';
  static const String notificationSettings = '/settings/notifications';
  static const String securitySettings = '/settings/security';
  static const String about = '/settings/about';
  static const String endedBroadcast = '/endedBroadcast';
  static const String biblePage = '/bible-page';
  static const String broadcasts = '/broadcasts';
  static const String broadcastDetails = '/broadcasts/:id';

  static const String liveSessionInitialization = '/live-initialization';
  static const String broadcastTab = '/broadcast-tab';
  static const String chatTab = '/chat-tab';
  static const String bibleTab = '/bible-tab';
  static const String notesTab = '/notes-tab';
  static const String notesTabEditor = 'notes-tab-editor';
  static const String notesTabEditorFull = '/notes-tab/notes-tab-editor';

  static const String noteSection = '/notes-section';
  static const String folderSection = '/folder-section';

  static const String profiles = '/profiles';

  static String profile(String id) => '/profiles/$id';

  static const String noteEditorName = 'note-editor';

  static String noteEditor([String? id]) => '/note-editor/${id ?? 'new'}';
}

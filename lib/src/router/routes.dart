part of 'router.dart';

class Routes {
  Routes._();

  static const String startup = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String partialLogin = '/login?isPasswordOnly=true';
  static const String loginWithLeading = '/login?implyLeading=true';
  static const String register = '/register';
  static const String registerWithLeading = '//register?implyLeading=true';
  static const String registerWithoutLeading = '/register?implyLeading=false';
  static const String emailVerification = '/emailVerification';
  static const String loading = '/loading';
  static const String resetPassword = '/resetPassword';
  static const String resetPwdOtp = '/resetPasswordOtp';
  static const String resetPwdSuccess = '/resetPasswordSuccess';
  static const String createNewPassword = '/createNewPassword';
  static const String broadcast = '/broadcast';
  static const String webCreateBroadcast = '/web-createBroadcast';
  static const String createBroadcast = '/createBroadcast';
  static const String stream = '/stream';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String notes = '/notes';
  static const String profile = '/profile';
  static const String recentlyLive = '/recentlyLive';
  static const String details = '/details';
  static const String notifications = '/notifications';
  static const String bible = '/bible';
  static const String chat = '/chat';
  static const String noteEditor = '/noteEditor';
  static const String folder = '/folder';
  static const String settings = '/settings';
}

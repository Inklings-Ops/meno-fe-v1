import 'package:meno_fe_v1/src/router/router.dart';

enum SessionStatus {
  loading(
    redirectPath: Routes.loading,
    allowedPaths: [Routes.loading],
  ),

  onboarding(
    redirectPath: Routes.onboarding,
    allowedPaths: [
      Routes.login,
      Routes.register,
      Routes.createNewPassword,
      Routes.emailVerification,
      Routes.loginWithLeading,
      Routes.registerWithLeading,
      Routes.registerWithoutLeading,
      Routes.resetPassword,
      Routes.resetPwdOtp,
      Routes.resetPwdSuccess,
      Routes.returnLogin,
    ],
  ),

  partiallyAuthenticated(
    redirectPath: Routes.partialLogin,
    allowedPaths: [
      Routes.register,
      Routes.login,
      Routes.createNewPassword,
      Routes.emailVerification,
      Routes.loginWithLeading,
      Routes.registerWithLeading,
      Routes.registerWithoutLeading,
      Routes.resetPassword,
      Routes.resetPwdOtp,
      Routes.resetPwdSuccess,
      Routes.returnLogin,
    ],
  ),

  unauthenticated(
    redirectPath: Routes.login,
    allowedPaths: [
      Routes.register,
      Routes.login,
      Routes.createNewPassword,
      Routes.emailVerification,
      Routes.loginWithLeading,
      Routes.registerWithLeading,
      Routes.registerWithoutLeading,
      Routes.resetPassword,
      Routes.resetPwdOtp,
      Routes.resetPwdSuccess,
      Routes.returnLogin,
    ],
  ),

  authenticated(
    redirectPath: Routes.home,
    allowedPaths: [
      Routes.home,
      Routes.profile,
      Routes.bible,
      Routes.broadcast,
      Routes.chat,
      Routes.createBroadcast,
      Routes.details,
      Routes.discover,
      Routes.folder,
      Routes.home,
      Routes.noteEditor,
      Routes.notes,
      Routes.notifications,
      Routes.profile,
      Routes.recentlyLive,
      Routes.settings,
      Routes.stream,
    ],
  );

  const SessionStatus({
    required this.redirectPath,
    required this.allowedPaths,
  });

  /// The target path to redirect when the current route is not allowed in this
  /// auth state.
  final String redirectPath;

  /// List of paths allowed when the app is in this auth state.
  final List<String> allowedPaths;
}

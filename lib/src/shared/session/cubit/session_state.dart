part of 'session_cubit.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState.loading() = _SessionLoading;
  const factory SessionState.onboarding() = _SessionOnboarding;
  const factory SessionState.unauthenticated() = _SessionUnauthenticated;
  const factory SessionState.partiallyAuthenticated({
    required User user,
  }) = _SessionPartiallyAuth;
  const factory SessionState.authenticated({
    required User user,
    required Token token,
  }) = _SessionAuthenticated;
}

extension SessionStateX on SessionState {
  String get redirectPath {
    return when(
      authenticated: (user, token) => Routes.home,
      partiallyAuthenticated: (user) => Routes.partialLogin,
      unauthenticated: () => Routes.login,
      onboarding: () => Routes.onboarding,
      loading: () => Routes.loading,
    );
  }

  List<String> get allowedPaths {
    return when(
      loading: () => [Routes.loading],
      onboarding: () => [
        Routes.login,
        Routes.register,
        Routes.createNewPassword,
        Routes.emailVerification,
        Routes.loginWithLeading,
        Routes.registerWithoutLeading,
        Routes.registerWithLeading,
        Routes.resetPassword,
        Routes.resetPwdOtp,
        Routes.resetPwdSuccess,
      ],
      unauthenticated: () => [
        Routes.register,
        Routes.login,
        Routes.createNewPassword,
        Routes.emailVerification,
        Routes.loginWithLeading,
        Routes.registerWithoutLeading,
        Routes.registerWithLeading,
        Routes.resetPassword,
        Routes.resetPwdOtp,
        Routes.resetPwdSuccess,
      ],
      partiallyAuthenticated: (user) => [
        Routes.register,
        Routes.login,
        Routes.createNewPassword,
        Routes.emailVerification,
        Routes.loginWithLeading,
        Routes.registerWithoutLeading,
        Routes.registerWithLeading,
        Routes.resetPassword,
        Routes.resetPwdOtp,
        Routes.resetPwdSuccess,
        Routes.partialLogin,
      ],
      authenticated: (user, token) => [
        Routes.home,
        Routes.broadcast,
        Routes.stream,
        Routes.webCreateBroadcast,
        Routes.createBroadcast,
        Routes.details,
        Routes.discover,
        Routes.folder,
        Routes.home,
        Routes.noteEditor,
        Routes.notes,
        Routes.notifications,
        Routes.myProfile,
        Routes.othersProfile,
        Routes.recentlyLive,
        Routes.settings,
        Routes.endedBroadcast,
        Routes.broadcastTab,
        Routes.chatTab,
        Routes.bibleTab,
        Routes.notesTab,
        Routes.noteTabEditor,
        Routes.noteSection,
        Routes.folderSection,
        Routes.noteCardOptionsModal,
        Routes.addNoteToFolderModal,
        Routes.folderFormModal,
        Routes.deleteNoteDialog,
        Routes.deleteFolderDialog,
        Routes.remoteNoteFromFolderDialog,
      ],
    );
  }
}

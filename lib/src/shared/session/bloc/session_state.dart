part of 'session_bloc.dart';

sealed class SessionState with EquatableMixin {
  const SessionState();

  @override
  List<Object?> get props => [];
}

final class SessionLoadInProgress extends SessionState {
  const SessionLoadInProgress();
}

final class SessionOnboarding extends SessionState {
  const SessionOnboarding();
}

final class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

final class SessionPartiallyAuthenticated extends SessionState {
  const SessionPartiallyAuthenticated(this.user);
  final User user;

  @override
  List<Object?> get props => [user];
}

final class SessionAuthenticated extends SessionState {
  const SessionAuthenticated(this.user, this.token);
  final User user;
  final Token token;

  @override
  List<Object?> get props => [user, token];
}

extension SessionStateX on SessionState {
  String get redirectPath {
    return switch (this) {
      SessionAuthenticated() => Routes.home,
      SessionPartiallyAuthenticated() => Routes.partialLogin,
      SessionUnauthenticated() => Routes.login,
      SessionOnboarding() => Routes.onboarding,
      SessionLoadInProgress() => Routes.loading,
    };
  }

  List<String> get allowedPaths {
    return switch (this) {
      SessionLoadInProgress() => [Routes.loading],
      SessionOnboarding() => [
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
      SessionUnauthenticated() => [
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
          Routes.pickImageModal,
        ],
      SessionPartiallyAuthenticated() => [
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
          Routes.pickImageModal,
        ],
      SessionAuthenticated() => [
          Routes.home,
          Routes.webCreateBroadcast,
          Routes.createBroadcast,
          Routes.discover,
          Routes.folder,
          Routes.home,
          Routes.noteEditor,
          Routes.notes,
          Routes.notifications,
          Routes.myProfile,
          Routes.othersProfile,
          Routes.nowLive,
          Routes.recentlyLive,
          Routes.settings,
          Routes.endedBroadcast,
          Routes.broadcastTab,
          Routes.chatTab,
          Routes.bibleTab,
          Routes.notesTab,
          Routes.notesTabEditor,
          Routes.notesTabEditorFull,
          Routes.noteSection,
          Routes.folderSection,
          Routes.noteCardOptionsModal,
          Routes.addNoteToFolderModal,
          Routes.moveNoteToFolderModal,
          Routes.notesModal,
          Routes.folderFormModal,
          Routes.deleteNoteDialog,
          Routes.deleteFolderDialog,
          Routes.remoteNoteFromFolderDialog,
          Routes.othersProfileOptionsModal,
          Routes.editProfileModal,
          Routes.preStreamModal,
          Routes.biblePage,
          Routes.switchAccountModal,
          Routes.broadcastInfoModal,
          Routes.notificationSettings,
          Routes.securitySettings,
          Routes.about,
          Routes.logoutConfirmationDialog,
          Routes.pickImageModal,
          Routes.broadcasts,
          Routes.broadcastDetails,
        ],
    };
  }
}

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
  static const String webCreateBroadcast = '/web-createBroadcast';
  static const String createBroadcast = '/createBroadcast';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String notes = '/notes';
  static const String myProfile = '/my-profile';
  static const String othersProfile = '/others-profile';
  static const String nowLive = '/nowLive';
  static const String recentlyLive = '/recentlyLive';
  static const String details = '/details';
  static const String notifications = '/notifications';
  static const String noteEditor = '/noteEditor';
  static const String folder = '/folder';
  static const String settings = '/settings';
  static const String endedBroadcast = '/endedBroadcast';
  static const String chatPage = '/chatPage';

  static const String broadcastTab = '/broadcast-tab';
  static const String chatTab = '/chat-tab';
  static const String bibleTab = '/bible-tab';
  static const String notesTab = '/notes-tab';
  static const String notesTabEditor = 'notes-tab-editor';
  static const String notesTabEditorFull = '/notes-tab/notes-tab-editor';

  static const String noteSection = '/notes-section';
  static const String folderSection = '/folder-section';

  static const String preStreamModal = '/pre-stream-modal';
  static const String noteCardOptionsModal = '/note-card-options-modal';
  static const String addNoteToFolderModal = '/add-note-to-folder-modal';
  static const String moveNoteToFolderModal = '/move-note-to-folder-modal';
  static const String folderFormModal = '/create-new-folder-modal';
  static const String notesModal = '/notes-modal';
  static const String othersProfileOptionsModal =
      '/others-profile-options-modal';
  static const String editProfileModal = '/edit-profile-modal';

  static const String deleteNoteDialog = '/delete-note-dialog';
  static const String deleteFolderDialog = '/delete-folder-dialog';
  static const String remoteNoteFromFolderDialog = '/remove-note-folder-dialog';
}

class ModalPage<T> extends Page<void> {
  const ModalPage({
    required this.child,
    super.key,
    this.constraints,
    this.isScrollControlled = false,
    this.useRootNavigator = false,
    this.isDismissible = true,
    this.enableDrag = true,
  });

  final Widget child;
  final BoxConstraints? constraints;
  final bool isScrollControlled;
  final bool useRootNavigator;
  final bool isDismissible;
  final bool enableDrag;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      builder: (context) => Material(child: child),
      constraints: constraints,
      backgroundColor: MColorScheme.of(context)?.background,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: true,
      useSafeArea: true,
      settings: this,
    );
  }
}

class DialogPage<T> extends Page<void> {
  const DialogPage({
    required this.builder,
    super.key,
    this.barrierDismissible = true,
    this.barrierColor,
  });

  final WidgetBuilder builder;
  final bool barrierDismissible;
  final Color? barrierColor;

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      context: context,
      builder: builder,
      settings: this,
      useSafeArea: false,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
    );
  }
}

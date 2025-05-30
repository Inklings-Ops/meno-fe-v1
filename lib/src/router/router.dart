import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'routes.dart';

// String? _initialDeepLink;
// String? get initialDeepLink => _initialDeepLink;

final rootNavigatorKey = GlobalKey<NavigatorState>();
final mainLayoutKey = GlobalKey<NavigatorState>();
final broadcastLayoutKey = GlobalKey<NavigatorState>();

final broadcastTabKey = GlobalKey<NavigatorState>();
final streamTabKey = GlobalKey<NavigatorState>();
final chatTabKey = GlobalKey<NavigatorState>();
final bibleTabKey = GlobalKey<NavigatorState>();
final notesTabKey = GlobalKey<NavigatorState>();

final homeKey = GlobalKey<NavigatorState>();
final discoverKey = GlobalKey<NavigatorState>();
final notesKey = GlobalKey<NavigatorState>();
final profileKey = GlobalKey<NavigatorState>();

final notesLayoutKey = GlobalKey<NavigatorState>();
final noteSectionKey = GlobalKey<NavigatorState>();
final folderSectionKey = GlobalKey<NavigatorState>();

FutureOr<String?> _handleRedirect(BuildContext context, GoRouterState state) {
  final status = di<SessionBloc>().authState.value;
  final isAllowedPath = status.allowedPaths.contains(state.fullPath);
  if (!isAllowedPath) return status.redirectPath;
  return null;
}

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  refreshListenable: di<SessionBloc>().authState,
  redirect: _handleRedirect,
  routes: [
    GoRoute(
      path: Routes.createBroadcast,
      builder: (context, state) => const CreateBroadcastPage(),
    ),
    GoRoute(
      path: Routes.createNewPassword,
      builder: (context, state) => const CreateNewPasswordPage(),
    ),
    GoRoute(
      path: Routes.broadcastDetails,
      name: 'Broadcast Details',
      builder: (_, state) => BroadcastDetailsPage(
        id: ID.fromString(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: Routes.emailVerification,
      builder: (context, state) => const EmailVerificationPage(),
    ),
    GoRoute(
      path: Routes.folder,
      builder: (context, state) => BlocProvider(
        create: (context) => FolderBloc(
          facade: di<INoteFacade>(),
          folder: state.extra! as Folder,
        )..add(const FolderGetFolderNotesRequested()),
        child: const FolderPage(),
      ),
    ),
    GoRoute(
      path: Routes.loading,
      builder: (context, state) => const LoadingPage(),
    ),
    GoRoute(
      path: Routes.endedBroadcast,
      onExit: (ctx, state) {
        ctx.read<TimerCubit>().reset();
        ctx.read<ChatListBloc>().add(const ChatResetRequested());
        ctx.read<ParticipantsBloc>().add(const ParticipantsResetRequested());
        ctx.read<BroadcastBloc>().add(const BroadcastResetRequested());
        return true;
      },
      builder: (context, state) => const EndedBroadcastPage(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        final q = state.uri.queryParameters;
        final isPasswordOnly = bool.parse(q['isPasswordOnly'] ?? 'false');
        final implyLeading = bool.parse(q['implyLeading'] ?? 'false');
        return LoginPage(
          implyLeading: implyLeading,
          isPasswordOnly: isPasswordOnly,
        );
      },
    ),
    GoRoute(
      path: Routes.noteEditor,
      builder: (context, state) {
        final note = state.extra as Note? ?? Note.empty;
        return BlocProvider(
          create: (_) => NoteEditorBloc(
            facade: di<INoteFacade>(),
          )..add(NoteEditorInitializeRequested(note)),
          child: NoteEditorPage(note: note),
        );
      },
    ),
    GoRoute(
      path: Routes.notifications,
      builder: (context, state) => BlocProvider(
        create: (_) => NotificationsBloc(
          facade: di<INotificationFacade>(),
        )..add(const NotificationsFetchRequested()),
        child: const NotificationsPage(),
      ),
    ),
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) {
        final q = state.uri.queryParameters;
        final implyLeading = bool.parse(q['isPasswordOnly'] ?? 'true');
        return RegisterPage(implyLeading: implyLeading);
      },
    ),
    GoRoute(
      path: Routes.resetPwdOtp,
      builder: (context, state) => const ResetPasswordOtpVerificationPage(),
    ),
    GoRoute(
      path: Routes.resetPassword,
      builder: (context, state) => const ResetPasswordPage(),
    ),
    GoRoute(
      path: Routes.resetPwdSuccess,
      builder: (context, state) => const ResetPasswordSuccessPage(),
    ),
    GoRoute(
      path: Routes.othersProfile,
      builder: (_, state) {
        final userId = ID.fromString(state.extra! as String);
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => OthersProfileCubit(
                facade: di<IProfileFacade>(),
                userId: userId,
              )..fetch(),
            ),
            BlocProvider(
              create: (_) => UsersRecentBroadcastsBloc(
                facade: di<IBroadcastFacade>(),
                userId: userId,
              )..add(const UsersRecentBroadcastsFetchRequested()),
            ),
            BlocProvider(
              create: (_) => UsersAllBroadcastsBloc(
                facade: di<IBroadcastFacade>(),
                userId: userId,
              )..add(const UsersAllBroadcastsFetchRequested()),
            ),
          ],
          child: const OthersProfilePage(),
        );
      },
    ),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: Routes.notificationSettings,
      builder: (context, state) => const NotificationsSettingsPage(),
    ),
    GoRoute(
      path: Routes.securitySettings,
      builder: (context, state) => const SecuritySettingsPage(),
    ),
    GoRoute(
      path: Routes.about,
      builder: (context, state) => const AboutPage(),
    ),

    GoRoute(
      path: Routes.notificationSettings,
      builder: (context, state) => const NotificationsSettingsPage(),
    ),

    GoRoute(
      path: Routes.broadcasts,
      name: 'Broadcasts',
      builder: (context, state) => BroadcastsPage(
        type: stringToBroadcastPageType(state.uri.queryParameters['type']),
        orderBy: stringToOrderBy(state.uri.queryParameters['order-by']),
        sortBy: state.uri.queryParameters['sort-by']!,
        page: _mapValue('page', state.uri.queryParameters, int.parse) ?? 1,
        size: _mapValue('size', state.uri.queryParameters, int.parse) ?? 10,
        startTimeExists: _mapValue(
          'start-time-exists',
          state.uri.queryParameters,
          _boolValue,
        ),
        endTimeExists: _mapValue(
          'end-time-exists',
          state.uri.queryParameters,
          _boolValue,
        ),
        include: state.uri.queryParameters['include'],
        status: state.uri.queryParameters['status'],
        creatorId: state.uri.queryParameters['creator-id'],
      ),
    ),

    /// Modals
    ///
    /// Folder Form Modal: Shows the modal to create a new folder
    GoRoute(
      path: Routes.preStreamModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => ModalPage<dynamic>(
        isScrollControlled: true,
        child: PreStreamModal(broadcast: state.extra! as Broadcast),
      ),
    ),
    GoRoute(
      path: Routes.folderFormModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final folder = state.extra as Folder? ?? Folder.empty;
        return ModalPage<dynamic>(
          isScrollControlled: true,
          child: BlocProvider(
            create: (_) => FolderFormBloc(
              facade: di<INoteFacade>(),
            )..add(FolderFormInitializeRequested(folder)),
            child: CreateFolderModal(initialFolder: folder),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.noteCardOptionsModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return ModalPage<dynamic>(
          isScrollControlled: true,
          child: NoteCardOptionsModal(
            note: extra['note'] as Note,
            folderId: extra['folderId'] as ID?,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.addNoteToFolderModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => ModalPage<dynamic>(
        child: AddNoteToFolderModal(note: state.extra! as Note),
        isScrollControlled: true,
      ),
    ),
    GoRoute(
      path: Routes.moveNoteToFolderModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return ModalPage<dynamic>(
          isScrollControlled: true,
          child: MoveNoteToFolderModal(
            note: extra['note'] as Note,
            folderId: extra['folderId'] as ID,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.notesModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => ModalPage<dynamic>(
        child: AddNotesToFolderModal(folder: state.extra! as Folder),
        isScrollControlled: true,
      ),
    ),
    GoRoute(
      path: Routes.othersProfileOptionsModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => const ModalPage<dynamic>(
        child: OthersProfileOptionsModal(),
        isScrollControlled: true,
      ),
    ),
    GoRoute(
      path: Routes.editProfileModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final profile = state.extra as Profile?;
        return ModalPage<dynamic>(
          child: BlocProvider.value(
            value: BlocProvider.of<ProfileFormCubit>(context)
              ..initializeWithProfile(profile),
            child: const EditProfileModal(),
          ),
          isScrollControlled: true,
        );
      },
    ),
    GoRoute(
      path: Routes.switchAccountModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => ModalPage<dynamic>(
        child: BlocProvider.value(
          value: context.read<AccountBloc>()..add(const AccountInitialized()),
          child: const MSwitchAccountModal(),
        ),
        isScrollControlled: true,
      ),
    ),
    GoRoute(
      path: Routes.broadcastInfoModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final broadcast = context.read<BroadcastBloc>().state.broadcast;
        return ModalPage<dynamic>(
          child: BroadcastInfoModal(broadcast: broadcast),
          isScrollControlled: true,
        );
      },
    ),

    /// Dialogs
    ///
    GoRoute(
      path: Routes.deleteNoteDialog,
      pageBuilder: (context, state) => DialogPage<void>(
        key: state.pageKey,
        barrierDismissible: false,
        builder: (context) => DeleteNoteAlertDialog(note: state.extra! as Note),
      ),
    ),

    GoRoute(
      path: Routes.deleteFolderDialog,
      pageBuilder: (context, state) => DialogPage<void>(
        key: state.pageKey,
        barrierDismissible: false,
        builder: (_) => DeleteFolderAlertDialog(folder: state.extra! as Folder),
      ),
    ),

    GoRoute(
      path: Routes.remoteNoteFromFolderDialog,
      pageBuilder: (context, state) => DialogPage<void>(
        key: state.pageKey,
        barrierDismissible: false,
        builder: (context) => RemoveNoteFromFolderAlertDialog(
          note: state.extra! as Note,
        ),
      ),
    ),
    GoRoute(
      path: Routes.logoutConfirmationDialog,
      pageBuilder: (context, state) => DialogPage<void>(
        key: state.pageKey,
        builder: (context) => const LogoutConfirmationDialog(),
      ),
    ),

    /// Shell Routes
    ///
    /// Live Broadcast/Stream Shell Route
    StatefulShellRoute(
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state, navigationShell) => navigationShell,
      navigatorContainerBuilder: (context, navigationShell, children) {
        final bibleFac = di<IBibleFacade>();
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => VersesCubit(facade: bibleFac)),
            BlocProvider(create: (_) => ScripturePickerCubit(facade: bibleFac)),
          ],
          child: LiveLayout(
            key: broadcastLayoutKey,
            navigationShell: navigationShell,
            children: children,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: broadcastTabKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.broadcastTab,
              builder: (context, state) {
                if (state.extra == null) return const LiveBroadcastTab();
                return const LiveStreamTab();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: chatTabKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.chatTab,
              builder: (context, state) => const LiveChatTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: bibleTabKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.bibleTab,
              builder: (context, state) => const LiveBibleTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: notesTabKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.notesTab,
              builder: (context, state) => const LiveNotesTab(),
              routes: [
                GoRoute(
                  parentNavigatorKey: notesTabKey,
                  path: Routes.notesTabEditor,
                  builder: (context, state) {
                    final note = state.extra as Note? ?? Note.empty;
                    return BlocProvider(
                      create: (_) => NoteEditorBloc(
                        facade: di<INoteFacade>(),
                      )..add(NoteEditorInitializeRequested(note)),
                      child: NoteEditorPage(note: note),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    /// Main Shell Route
    /// Houses the main [MLayoutPage] with the apps bottom navigation bar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MLayoutPage(
        key: mainLayoutKey,
        shell: navigationShell,
        currentRoute: state.path,
      ),
      branches: [
        StatefulShellBranch(
          navigatorKey: homeKey,
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: discoverKey,
          routes: [
            GoRoute(
              path: Routes.discover,
              builder: (context, state) => const DiscoverPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: notesKey,
          routes: [
            /// Notes Page Shell Route
            StatefulShellRoute(
              builder: (context, state, navigationShell) => navigationShell,
              navigatorContainerBuilder: (context, navigationShell, children) {
                final facade = di<INoteFacade>();
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => FolderBloc(
                        facade: facade,
                        folder: Folder.empty,
                      ),
                    ),
                  ],
                  child: NotesPageLayout(
                    key: notesLayoutKey,
                    navigationShell: navigationShell,
                    children: children,
                  ),
                );
              },
              branches: [
                StatefulShellBranch(
                  navigatorKey: noteSectionKey,
                  routes: [
                    GoRoute(
                      path: Routes.noteSection,
                      builder: (context, state) => const NoteListWidget(),
                    ),
                  ],
                ),
                StatefulShellBranch(
                  navigatorKey: folderSectionKey,
                  routes: [
                    GoRoute(
                      path: Routes.folderSection,
                      builder: (context, state) => const FolderListWidget(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: profileKey,
          routes: [
            GoRoute(
              path: Routes.myProfile,
              builder: (context, state) => const MyProfilePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.webCreateBroadcast,
              builder: (context, state) => const CreateBroadcastPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

extension GoRouteX on GoRouter {
  void popAndPush(String location, {Object? extra}) {
    pop();
    push(location, extra: extra);
  }
}

T? _mapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _boolValue(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

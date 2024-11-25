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
  final status = di<SessionCubit>().state;
  final isAllowedPath = status.allowedPaths.contains(state.fullPath);
  if (!isAllowedPath) return status.redirectPath;
  return null;
}

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  refreshListenable: di<SessionCubit>(),
  redirect: _handleRedirect,
  routes: [
    GoRoute(
      path: Routes.broadcast,
      builder: (context, state) => const BroadcastPage(),
    ),
    GoRoute(
      path: Routes.stream,
      builder: (context, state) => const StreamPage(),
    ),
    GoRoute(
      path: Routes.createBroadcast,
      builder: (context, state) => const CreateBroadcastPage(),
    ),
    GoRoute(
      path: Routes.createNewPassword,
      builder: (context, state) => const CreateNewPasswordPage(),
    ),
    GoRoute(
      path: Routes.details,
      builder: (_, state) => DetailsPage(broadcast: state.extra! as Broadcast),
    ),
    GoRoute(
      path: Routes.emailVerification,
      builder: (context, state) => const EmailVerificationPage(),
    ),
    GoRoute(
      path: Routes.folder,
      builder: (context, state) => BlocProvider(
        create: (context) => FolderCubit(
          facade: di<INoteFacade>(),
          folder: state.extra! as Folder,
        )..getAllNotes(),
        child: const FolderPage(),
      ),
    ),
    GoRoute(
      path: Routes.loading,
      builder: (context, state) => const LoadingPage(),
    ),
    GoRoute(
      path: Routes.endedBroadcast,
      onExit: (context, state) {
        context.read<TimerCubit>().dispose();
        context.read<ParticipantsBloc>().add(const ParticipantsReset());
        context.read<BroadcastBloc>().add(const BroadcastReset());
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
        final note = state.extra as Note? ?? Note.empty();
        return BlocProvider(
          create: (_) => NoteEditorBloc(
            facade: di<INoteFacade>(),
          )..add(InitializeNoteEditor(note)),
          child: NoteEditorPage(note: note),
        );
      },
    ),
    GoRoute(
      path: Routes.notifications,
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.recentlyLive,
      builder: (context, state) => const RecentlyLivePage(),
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
      builder: (_, state) => OthersProfilePage(userId: state.extra! as String),
    ),

    /// Modals
    ///
    /// Folder Form Modal: Shows the modal to create a new folder
    GoRoute(
      path: Routes.folderFormModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final folder = state.extra as Folder? ?? Folder.empty();
        return ModalPage<dynamic>(
          isScrollControlled: true,
          child: BlocProvider(
            create: (_) => FolderFormBloc(
              facade: di<INoteFacade>(),
            )..add(InitializeFolderForm(folder)),
            child: CreateFolderModal(initialFolder: folder),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.noteCardOptionsModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => ModalPage<dynamic>(
        child: BlocProvider(
          create: (context) => NotesWatcherBloc(facade: di<INoteFacade>()),
          child: NoteCardOptionsModal(note: state.extra! as Note),
        ),
        isScrollControlled: true,
      ),
    ),
    GoRoute(
      path: Routes.addNoteToFolderModal,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => ModalPage<dynamic>(
        child: BlocProvider(
          create: (context) => NotesWatcherBloc(facade: di<INoteFacade>()),
          child: AddNoteToFolderModal(note: state.extra! as Note),
        ),
        isScrollControlled: true,
      ),
    ),

    /// Dialogs
    ///
    GoRoute(
      path: Routes.deleteNoteDialog,
      pageBuilder: (context, state) => DialogPage<void>(
        key: state.pageKey,
        barrierDismissible: false,
        builder: (context) => BlocProvider(
          create: (context) => NotesWatcherBloc(facade: di<INoteFacade>()),
          child: DeleteNoteAlertDialog(note: state.extra! as Note),
        ),
      ),
    ),

    GoRoute(
      path: Routes.remoteNoteFromFolderDialog,
      pageBuilder: (context, state) => DialogPage<void>(
        key: state.pageKey,
        barrierDismissible: false,
        builder: (context) => BlocProvider(
          create: (context) => NotesWatcherBloc(facade: di<INoteFacade>()),
          child: RemoveNoteFromFolderAlertDialog(note: state.extra! as Note),
        ),
      ),
    ),

    /// Shell Routes
    ///
    /// Live Broadcast/Stream Shell Route
    StatefulShellRoute(
      builder: (context, state, navigationShell) => navigationShell,
      navigatorContainerBuilder: (context, navigationShell, children) {
        final bibleFac = di<IBibleFacade>();
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => VersesCubit(facade: bibleFac)),
            BlocProvider(create: (_) => ScripturePickerCubit(facade: bibleFac)),
            BlocProvider(create: (_) => TransBloc(facade: bibleFac)),
            BlocProvider(create: (_) => NotesBloc(facade: di<INoteFacade>())),
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
                if (state.extra == null) return const BroadcastTab();
                return const StreamTab();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: chatTabKey,
          routes: <RouteBase>[
            GoRoute(
              path: Routes.chatTab,
              builder: (context, state) => const ChatTab(),
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
              builder: (context, state) => const NotesTab(),
              routes: [
                GoRoute(
                  parentNavigatorKey: notesTabKey,
                  path: Routes.noteTabEditor,
                  builder: (context, state) {
                    final note = state.extra as Note? ?? Note.empty();
                    return BlocProvider(
                      create: (_) => NoteEditorBloc(
                        facade: di<INoteFacade>(),
                      )..add(InitializeNoteEditor(note)),
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
                final f = di<INoteFacade>();
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => FolderCubit(
                        facade: f,
                        folder: Folder.empty(),
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

extension GoRouteX on GoRouter {
  void popAndPush(String location) {
    pop();
    push(location);
  }
}

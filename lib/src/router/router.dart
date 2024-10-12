import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'routes.dart';

// String? _initialDeepLink;
// String? get initialDeepLink => _initialDeepLink;

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> layoutKey = GlobalKey<NavigatorState>();

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
    StatefulShellRoute(
      builder: (context, state, navigationShell) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => BroadcastBloc(
              broadcast: state.extra! as Broadcast,
              facade: ctx.read<IBroadcastFacade>(),
              liveKit: ctx.read<LiveKitService>(),
              socket: ctx.read<SocketService>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => LiveParticipantsBloc(
              socket: ctx.read<SocketService>(),
              facade: ctx.read<IBroadcastFacade>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => ChatBloc(
              profileFacade: ctx.read<IProfileFacade>(),
              session: ctx.read<ISessionContext>(),
              socket: ctx.read<SocketService>(),
            ),
          ),
        ],
        child: navigationShell,
      ),
      navigatorContainerBuilder: (context, navigationShell, children) {
        return LiveStreamScaffold(shell: navigationShell, children: children);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.broadcastTab,
              builder: (context, state) => const BroadcastTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.chatTab,
              builder: (context, state) => const BroadcastChatTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.bibleTab,
              builder: (context, state) => const LiveBibleTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.notesTab,
              builder: (context, state) => const NotesTab(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.createBroadcast,
      builder: (context, state) => BlocProvider(
        create: (ctx) => BroadcastFormCubit(
          facade: ctx.read<IBroadcastFacade>(),
          mediaService: ctx.read<MediaService>(),
        ),
        child: const CreateBroadcastPage(),
      ),
    ),
    GoRoute(
      path: Routes.createNewPassword,
      builder: (context, state) => const CreateNewPasswordPage(),
    ),
    GoRoute(
      path: Routes.details,
      builder: (context, state) => DetailsPage(
        broadcast: state.extra! as Broadcast,
      ),
    ),
    GoRoute(
      path: Routes.emailVerification,
      builder: (context, state) => const EmailVerificationPage(),
    ),
    GoRoute(
      path: Routes.folder,
      builder: (context, state) {
        final folder = state.extra! as Folder;
        return BlocProvider(
          create: (_) => di<FolderCubit>(param1: folder),
          child: FolderPage(folder: folder),
        );
      },
    ),
    GoRoute(
      path: Routes.loading,
      builder: (context, state) => const LoadingPage(),
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
        final note = state.extra as Note?;
        return BlocProvider.value(
          value: di<NoteFormCubit>(param1: note),
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
      path: Routes.stream,
      builder: (context, state) => const StreamPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MLayoutPage(
        shell: navigationShell,
        currentRoute: state.path,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.discover,
              builder: (context, state) => const DiscoverPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.notes,
              builder: (context, state) => const NotesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profile,
              builder: (context, state) => ProfilePage(
                id: state.extra as String?,
              ),
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

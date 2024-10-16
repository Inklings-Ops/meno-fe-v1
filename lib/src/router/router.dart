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
    GoRoute(
      path: Routes.broadcast,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => BroadcastBloc(
              broadcast: state.extra! as Broadcast,
              facade: context.read<IBroadcastFacade>(),
              liveKit: context.read<LiveKitService>(),
              socket: context.read<SocketService>(),
            ),
          ),
          BlocProvider(
            create: (context) => LiveParticipantsBloc(
              socket: context.read<SocketService>(),
              facade: context.read<IBroadcastFacade>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChatBloc(
              profileFacade: context.read<IProfileFacade>(),
              session: context.read<ISessionContext>(),
              socket: context.read<SocketService>(),
            ),
          ),
        ],
        child: const BroadcastPage(),
      ),
    ),
    GoRoute(
      path: Routes.stream,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LiveParticipantsBloc(
              socket: context.read<SocketService>(),
              facade: context.read<IBroadcastFacade>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChatBloc(
              profileFacade: context.read<IProfileFacade>(),
              session: context.read<ISessionContext>(),
              socket: context.read<SocketService>(),
            ),
          ),
        ],
        child: const StreamPage(),
      ),
    ),
    GoRoute(
      path: Routes.createBroadcast,
      builder: (context, state) => BlocProvider(
        create: (context) => BroadcastFormCubit(
          facade: context.read<IBroadcastFacade>(),
          mediaService: context.read<MediaService>(),
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

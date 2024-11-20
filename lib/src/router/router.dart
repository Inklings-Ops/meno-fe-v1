import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

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
      name: Routes.broadcast,
      path: Routes.broadcast,
      builder: (context, state) => const BroadcastPage(),
    ),
    GoRoute(
      name: Routes.stream,
      path: Routes.stream,
      builder: (context, state) => const StreamPage(),
    ),
    GoRoute(
      name: Routes.createBroadcast,
      path: Routes.createBroadcast,
      builder: (context, state) => const CreateBroadcastPage(),
    ),
    GoRoute(
      name: Routes.createNewPassword,
      path: Routes.createNewPassword,
      builder: (context, state) => const CreateNewPasswordPage(),
    ),
    GoRoute(
      name: Routes.details,
      path: Routes.details,
      builder: (_, state) => DetailsPage(broadcast: state.extra! as Broadcast),
    ),
    GoRoute(
      name: Routes.emailVerification,
      path: Routes.emailVerification,
      builder: (context, state) => const EmailVerificationPage(),
    ),
    GoRoute(
      name: Routes.folder,
      path: Routes.folder,
      builder: (context, state) {
        final folder = state.extra! as Folder;
        return BlocProvider.value(
          value: FolderCubit(facade: di<INoteFacade>(), folder: folder),
          child: FolderPage(folder: folder),
        );
      },
    ),
    GoRoute(
      name: Routes.loading,
      path: Routes.loading,
      builder: (context, state) => const LoadingPage(),
    ),
    GoRoute(
      name: Routes.endedBroadcast,
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
      name: Routes.login,
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
      name: Routes.noteEditor,
      path: Routes.noteEditor,
      builder: (context, state) {
        final note = state.extra as Note?;
        return BlocProvider(
          create: (_) => NoteEditorBloc(
            facade: di<INoteFacade>(),
            initialNote: note,
          ),
          child: NoteEditorPage(note: note),
        );
      },
      onExit: (context, state) {
        context.read<NotesBloc>().add(const ReloadNotes());
        return true;
      },
    ),
    GoRoute(
      name: Routes.notifications,
      path: Routes.notifications,
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(
      name: Routes.onboarding,
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      name: Routes.recentlyLive,
      path: Routes.recentlyLive,
      builder: (context, state) => const RecentlyLivePage(),
    ),
    GoRoute(
      name: Routes.register,
      path: Routes.register,
      builder: (context, state) {
        final q = state.uri.queryParameters;
        final implyLeading = bool.parse(q['isPasswordOnly'] ?? 'true');
        return RegisterPage(implyLeading: implyLeading);
      },
    ),
    GoRoute(
      name: Routes.resetPwdOtp,
      path: Routes.resetPwdOtp,
      builder: (context, state) => const ResetPasswordOtpVerificationPage(),
    ),
    GoRoute(
      name: Routes.resetPassword,
      path: Routes.resetPassword,
      builder: (context, state) => const ResetPasswordPage(),
    ),
    GoRoute(
      name: Routes.resetPwdSuccess,
      path: Routes.resetPwdSuccess,
      builder: (context, state) => const ResetPasswordSuccessPage(),
    ),
    GoRoute(
      name: Routes.othersProfile,
      path: Routes.othersProfile,
      builder: (_, state) => OthersProfilePage(userId: state.extra! as String),
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
              name: Routes.home,
              path: Routes.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.discover,
              path: Routes.discover,
              builder: (context, state) => const DiscoverPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.notes,
              path: Routes.notes,
              builder: (context, state) => const NotesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.myProfile,
              path: Routes.myProfile,
              builder: (context, state) => const MyProfilePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.webCreateBroadcast,
              path: Routes.webCreateBroadcast,
              builder: (context, state) => const CreateBroadcastPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: Routes.settings,
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

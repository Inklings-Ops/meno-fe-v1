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
      builder: (context, state) => FolderPage(folder: state.extra! as Folder),
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
      builder: (context, state) => NoteEditorPage(note: state.extra as Note?),
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

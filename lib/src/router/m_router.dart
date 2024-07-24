import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart';
import 'package:meno_fe_v1/src/shared/pages/onboarding/onboarding.dart';

part 'm_router.g.dart';

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  refreshListenable: di<SessionCubit>(),
  redirect: _handleRedirect,
  routes: $appRoutes,
);

String? _initialDeepLink;
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

String? get initialDeepLink => _initialDeepLink;

FutureOr<String?> _handleRedirect(BuildContext context, GoRouterState state) {
  final status = di<SessionCubit>().state;
  final isAllowedPath = status.allowedPaths.contains(state.fullPath);
  if (!isAllowedPath) return status.redirectPath;
  return null;
}

class BroadcastRoute extends GoRouteData {
  const BroadcastRoute();
  @override
  Widget build(context, state) {
    final broadcast = state.extra as Broadcast;
    return BroadcastPage(broadcast: broadcast);
  }
}

class CreateBroadcastRoute extends GoRouteData {
  const CreateBroadcastRoute();
  @override
  Widget build(context, state) => const CreateBroadcastPage();
}

class CreateNewPasswordRoute extends GoRouteData {
  const CreateNewPasswordRoute();
  @override
  Widget build(context, state) => const CreateNewPasswordPage();
}

class DetailsRoute extends GoRouteData {
  const DetailsRoute();
  @override
  Widget build(context, state) {
    final broadcast = (state.extra) as Broadcast;
    return DetailsPage(broadcast: broadcast);
  }
}

class DiscoverRoute extends GoRouteData {
  const DiscoverRoute();

  @override
  Widget build(context, state) => const DiscoverPage();
}

class DiscoverShellBranchData extends StatefulShellBranchData {
  const DiscoverShellBranchData();
}

class EmailVerificationRoute extends GoRouteData {
  const EmailVerificationRoute();
  @override
  Widget build(context, state) => const EmailVerificationPage();
}

class FolderRoute extends GoRouteData {
  const FolderRoute();
  @override
  Widget build(context, state) {
    final folder = state.extra as Folder;
    return BlocProvider(
      create: (_) => di<FolderCubit>(param1: folder),
      child: FolderPage(folder: folder),
    );
  }
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(context, state) => const HomePage();
}

class HomeShellBranchData extends StatefulShellBranchData {
  const HomeShellBranchData();
}

class LoadingRoute extends GoRouteData {
  const LoadingRoute();
  @override
  Widget build(context, state) => const LoadingPage();
}

class LoginRoute extends GoRouteData {
  const LoginRoute();
  @override
  Widget build(context, state) {
    final isPasswordOnly = state.uri.queryParameters['isPasswordOnly'];
    final implyLeading = state.uri.queryParameters['implyLeading'];
    return LoginPage(
      implyLeading: implyLeading == 'true' ? true : false,
      isPasswordOnly: isPasswordOnly == 'true' ? true : false,
    );
  }
}

class MLayoutShellBranchData extends StatefulShellBranchData {
  const MLayoutShellBranchData();
}

class MLayoutShellRoute extends StatefulShellRouteData {
  const MLayoutShellRoute();

  @override
  Widget builder(context, state, navigationShell) {
    return MLayout(shell: navigationShell);
  }
}

@TypedShellRoute<MenoShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<OnboardingRoute>(path: Routes.onboarding),
    TypedGoRoute<LoadingRoute>(path: Routes.loading),
    TypedGoRoute<CreateBroadcastRoute>(path: Routes.createBroadcast),
    TypedGoRoute<BroadcastRoute>(path: Routes.broadcast),
    TypedGoRoute<LoginRoute>(path: Routes.login),
    TypedGoRoute<RegisterRoute>(path: Routes.register),
    TypedGoRoute<ResetPasswordRoute>(path: Routes.resetPassword),
    TypedGoRoute<ResetPasswordOtpRoute>(path: Routes.resetPwdOtp),
    TypedGoRoute<ResetPasswordSuccessRoute>(path: Routes.resetPwdSuccess),
    TypedGoRoute<CreateNewPasswordRoute>(path: Routes.createNewPassword),
    TypedGoRoute<EmailVerificationRoute>(path: Routes.emailVerification),
    TypedGoRoute<StreamRoute>(path: Routes.stream),
    TypedGoRoute<RecentlyLiveRoute>(path: Routes.recentlyLive),
    TypedGoRoute<DetailsRoute>(path: Routes.details),
    TypedGoRoute<NotificationsRoute>(path: Routes.notifications),
    TypedGoRoute<NoteEditorRoute>(path: Routes.noteEditor),
    TypedGoRoute<FolderRoute>(path: Routes.folder),
    TypedGoRoute<SettingsRoute>(path: Routes.settings),
    TypedStatefulShellRoute<MLayoutShellRoute>(
      branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
        TypedStatefulShellBranch<HomeShellBranchData>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<HomeRoute>(path: Routes.home),
          ],
        ),
        TypedStatefulShellBranch<DiscoverShellBranchData>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<DiscoverRoute>(path: Routes.discover),
          ],
        ),
        TypedStatefulShellBranch<NotesShellBranchData>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<NotesRoute>(path: Routes.notes),
          ],
        ),
        TypedStatefulShellBranch<ProfileShellBranchData>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<ProfileRoute>(path: Routes.profile),
          ],
        ),
      ],
    ),
  ],
)
class MenoShellRoute extends ShellRouteData {
  const MenoShellRoute();
  @override
  Widget builder(context, state, navigator) => MenoScaffold(child: navigator);
}

class NoteEditorRoute extends GoRouteData {
  const NoteEditorRoute();
  @override
  Widget build(context, state) {
    final note = state.extra as Note?;
    return BlocProvider.value(
      value: di<NoteFormCubit>(param1: note),
      child: NoteEditorPage(note: note),
    );
  }
}

class NotesRoute extends GoRouteData {
  const NotesRoute();

  @override
  Widget build(context, state) => const NotesPage();
}

class NotesShellBranchData extends StatefulShellBranchData {
  const NotesShellBranchData();
}

class NotificationsRoute extends GoRouteData {
  const NotificationsRoute();
  @override
  Widget build(context, state) => const NotificationsPage();
}

class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();
  @override
  Widget build(context, state) => const OnboardingPage();
}

class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(context, state) => ProfilePage(id: state.extra as String?);
}

class ProfileShellBranchData extends StatefulShellBranchData {
  const ProfileShellBranchData();
}

class RecentlyLiveRoute extends GoRouteData {
  const RecentlyLiveRoute();
  @override
  Widget build(context, state) => const RecentlyLivePage();
}

class RegisterRoute extends GoRouteData {
  const RegisterRoute();
  @override
  Widget build(context, state) {
    final implyLeading = state.extra as bool?;
    return RegisterPage(implyLeading: implyLeading ?? true);
  }
}

class ResetPasswordOtpRoute extends GoRouteData {
  const ResetPasswordOtpRoute();
  @override
  Widget build(context, state) => const ResetPasswordOtpVerificationPage();
}

class ResetPasswordRoute extends GoRouteData {
  const ResetPasswordRoute();
  @override
  Widget build(context, state) => const ResetPasswordPage();
}

class ResetPasswordSuccessRoute extends GoRouteData {
  const ResetPasswordSuccessRoute();
  @override
  Widget build(context, state) => const ResetPasswordSuccessPage();
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();
  @override
  Widget build(context, state) => const SettingsPage();
}

class StreamRoute extends GoRouteData {
  const StreamRoute();
  @override
  Widget build(context, state) => const StreamPage();
}

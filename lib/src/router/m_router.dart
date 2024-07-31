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
  navigatorKey: rootNavigatorKey,
  refreshListenable: di<SessionCubit>(),
  redirect: _handleRedirect,
  routes: $appRoutes,
);

String? _initialDeepLink;
String? get initialDeepLink => _initialDeepLink;

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> layoutKey = GlobalKey<NavigatorState>();

FutureOr<String?> _handleRedirect(BuildContext context, GoRouterState state) {
  final status = di<SessionCubit>().state;
  final isAllowedPath = status.allowedPaths.contains(state.fullPath);
  if (!isAllowedPath) return status.redirectPath;
  return null;
}

@TypedGoRoute<BroadcastRoute>(path: Routes.broadcast)
class BroadcastRoute extends GoRouteData {
  const BroadcastRoute();
  @override
  Widget build(context, state) {
    final broadcast = state.extra as Broadcast;
    return BroadcastPage(broadcast: broadcast);
  }
}

@TypedGoRoute<CreateBroadcastRoute>(path: Routes.createBroadcast)
class CreateBroadcastRoute extends GoRouteData {
  const CreateBroadcastRoute();
  @override
  Widget build(context, state) => const CreateBroadcastPage();
}

@TypedGoRoute<CreateNewPasswordRoute>(path: Routes.createNewPassword)
class CreateNewPasswordRoute extends GoRouteData {
  const CreateNewPasswordRoute();
  @override
  Widget build(context, state) => const CreateNewPasswordPage();
}

@TypedGoRoute<DetailsRoute>(path: Routes.details)
class DetailsRoute extends GoRouteData {
  const DetailsRoute();
  @override
  Widget build(context, state) {
    final broadcast = (state.extra) as Broadcast;
    return DetailsPage(broadcast: broadcast);
  }
}

@TypedGoRoute<EmailVerificationRoute>(path: Routes.emailVerification)
class EmailVerificationRoute extends GoRouteData {
  const EmailVerificationRoute();
  @override
  Widget build(context, state) => const EmailVerificationPage();
}

@TypedGoRoute<FolderRoute>(path: Routes.folder)
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

@TypedGoRoute<LoadingRoute>(path: Routes.loading)
class LoadingRoute extends GoRouteData {
  const LoadingRoute();
  @override
  Widget build(context, state) => const LoadingPage();
}

@TypedGoRoute<LoginRoute>(path: Routes.login)
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

@TypedGoRoute<NoteEditorRoute>(path: Routes.noteEditor)
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

@TypedGoRoute<NotificationsRoute>(path: Routes.notifications)
class NotificationsRoute extends GoRouteData {
  const NotificationsRoute();
  @override
  Widget build(context, state) => const NotificationsPage();
}

@TypedGoRoute<OnboardingRoute>(path: Routes.onboarding)
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();
  @override
  Widget build(context, state) => const OnboardingPage();
}

@TypedGoRoute<RecentlyLiveRoute>(path: Routes.recentlyLive)
class RecentlyLiveRoute extends GoRouteData {
  const RecentlyLiveRoute();
  @override
  Widget build(context, state) => const RecentlyLivePage();
}

@TypedGoRoute<RegisterRoute>(path: Routes.register)
class RegisterRoute extends GoRouteData {
  const RegisterRoute();
  @override
  Widget build(context, state) {
    final implyLeading = state.extra as bool?;
    return RegisterPage(implyLeading: implyLeading ?? true);
  }
}

@TypedGoRoute<ResetPasswordOtpRoute>(path: Routes.resetPwdOtp)
class ResetPasswordOtpRoute extends GoRouteData {
  const ResetPasswordOtpRoute();
  @override
  Widget build(context, state) => const ResetPasswordOtpVerificationPage();
}

@TypedGoRoute<ResetPasswordRoute>(path: Routes.resetPassword)
class ResetPasswordRoute extends GoRouteData {
  const ResetPasswordRoute();
  @override
  Widget build(context, state) => const ResetPasswordPage();
}

@TypedGoRoute<ResetPasswordSuccessRoute>(path: Routes.resetPwdSuccess)
class ResetPasswordSuccessRoute extends GoRouteData {
  const ResetPasswordSuccessRoute();
  @override
  Widget build(context, state) => const ResetPasswordSuccessPage();
}

@TypedGoRoute<SettingsRoute>(path: Routes.settings)
class SettingsRoute extends GoRouteData {
  const SettingsRoute();
  @override
  Widget build(context, state) => const SettingsPage();
}

@TypedGoRoute<StreamRoute>(path: Routes.stream)
class StreamRoute extends GoRouteData {
  const StreamRoute();
  @override
  Widget build(context, state) => const StreamPage();
}

// Below handles the routes for the main layout for the bottom app bar
class HomeShellBranchData extends StatefulShellBranchData {
  const HomeShellBranchData();
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(context, state) => const HomePage();
}

class DiscoverShellBranchData extends StatefulShellBranchData {
  const DiscoverShellBranchData();
}

class DiscoverRoute extends GoRouteData {
  const DiscoverRoute();

  @override
  Widget build(context, state) => const DiscoverPage();
}

class NotesShellBranchData extends StatefulShellBranchData {
  const NotesShellBranchData();
}

class NotesRoute extends GoRouteData {
  const NotesRoute();

  @override
  Widget build(context, state) => const NotesPage();
}

class ProfileShellBranchData extends StatefulShellBranchData {
  const ProfileShellBranchData();
}

class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(context, state) => ProfilePage(id: state.extra as String?);
}

@TypedStatefulShellRoute<MLayoutShellRoute>(
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
)
class MLayoutShellRoute extends StatefulShellRouteData {
  const MLayoutShellRoute();

  @override
  Widget builder(context, state, navigationShell) {
    return MLayout(shell: navigationShell);
  }
}

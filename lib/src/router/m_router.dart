import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
import 'package:meno_fe_v1/src/features/discover/presentation/pages/discover_page.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder/folder_cubit.dart';
import 'package:meno_fe_v1/src/features/notes/application/note_form/note_form_cubit.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/pages/note_editor_page.dart';
import 'package:meno_fe_v1/src/features/settings/presentation/page/settings_page.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../features/auth/presentation/pages/create_new_password_page.dart';
import '../features/auth/presentation/pages/email_verification_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/reset_password_otp_verification_page.dart';
import '../features/auth/presentation/pages/reset_password_page.dart';
import '../features/auth/presentation/pages/reset_password_success_page.dart';
import '../features/bible/presentation/pages/bible_page.dart';
import '../features/broadcast/domain/entities/broadcast.dart';
import '../features/broadcast/presentation/pages/broadcast/broadcast_page.dart';
import '../features/broadcast/presentation/pages/create_broadcast/create_broadcast_page.dart';
import '../features/broadcast/presentation/pages/home/details_page.dart';
import '../features/broadcast/presentation/pages/home/home_page.dart';
import '../features/broadcast/presentation/pages/home/recently_live_page.dart';
import '../features/broadcast/presentation/pages/stream/stream_page.dart';
import '../features/notes/presentation/pages/folder_page.dart';
import '../features/notes/presentation/pages/notes_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

abstract class MRouter {
  static final routerConfig = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.home,
    refreshListenable: di<SessionCubit>(),
    redirect: (context, state) {
      final status = di<SessionCubit>().state;
      final isAllowedPath = status.allowedPaths.contains(state.fullPath);
      if (!isAllowedPath) return status.redirectPath;
      return null;
    },
    routes: [
      // GoRoute(
      //   path: Routes.startup,
      //   name: Routes.startup,
      //   builder: (context, gState) => const StartupPage(),
      // ),
      GoRoute(
        path: Routes.onboarding,
        name: Routes.onboarding,
        builder: (context, gState) => const OnboardingPage(),
      ),
      GoRoute(
        path: Routes.loading,
        name: Routes.loading,
        builder: (context, gState) => const LoadingPage(),
      ),
      GoRoute(
        path: Routes.createBroadcast,
        name: Routes.createBroadcast,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateBroadcastPage(),
      ),
      GoRoute(
        path: Routes.broadcast,
        name: Routes.broadcast,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BroadcastPage(),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        builder: (context, state) {
          final isPasswordOnly = state.uri.queryParameters['isPasswordOnly'];
          final implyLeading = state.uri.queryParameters['implyLeading'];
          return LoginPage(
            implyLeading: implyLeading == 'true' ? true : false,
            isPasswordOnly: isPasswordOnly == 'true' ? true : false,
          );
        },
      ),
      GoRoute(
        path: Routes.register,
        name: Routes.register,
        builder: (context, state) {
          final implyLeading = state.uri.queryParameters['implyLeading'];
          return RegisterPage(
            implyLeading: implyLeading == 'true' ? true : false,
          );
        },
      ),
      GoRoute(
        path: Routes.resetPassword,
        name: Routes.resetPassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: Routes.resetPwdOtp,
        name: Routes.resetPwdOtp,
        builder: (context, state) => const ResetPasswordOtpVerificationPage(),
      ),
      GoRoute(
        path: Routes.resetPwdSuccess,
        name: Routes.resetPwdSuccess,
        builder: (context, state) => const ResetPasswordSuccessPage(),
      ),
      GoRoute(
        path: Routes.createNewPassword,
        name: Routes.createNewPassword,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateNewPasswordPage(),
      ),
      GoRoute(
        path: Routes.emailVerification,
        name: Routes.emailVerification,
        builder: (context, state) => const EmailVerificationPage(),
      ),
      GoRoute(
        path: Routes.stream,
        name: Routes.stream,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StreamPage(),
      ),
      GoRoute(
        path: Routes.recentlyLive,
        name: Routes.recentlyLive,
        builder: (context, state) => const RecentlyLivePage(),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: Routes.details,
        name: Routes.details,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final broadcast = (state.extra) as Broadcast;
          return DetailsPage(broadcast: broadcast);
        },
      ),
      GoRoute(
        path: Routes.notifications,
        name: Routes.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: Routes.noteEditor,
        name: Routes.noteEditor,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return BlocProvider.value(
            value: di<NoteFormCubit>(param1: data?['note'] as Note?),
            child: NoteEditorPage(note: data?['note'] as Note?),
          );
        },
      ),
      GoRoute(
        path: Routes.folder,
        name: Routes.folder,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final folder = data?['folder'] as Folder;
          return BlocProvider(
            create: (_) => FolderCubit(
              facade: di<INoteFacade>(),
              folder: folder,
            )..getAllNotes(),
            child: FolderPage(folder: folder),
          );
        },
      ),
      GoRoute(
        path: Routes.bible,
        name: Routes.bible,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BiblePage(),
      ),
      GoRoute(
        path: Routes.settings,
        name: Routes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MLayout(shell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.home,
                name: Routes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.discover,
                name: Routes.discover,
                builder: (context, state) => const DiscoverPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.notes,
                name: Routes.notes,
                builder: (context, state) => const NotesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.profile,
                name: Routes.profile,
                builder: (context, state) => ProfilePage(
                  id: state.extra as String?,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

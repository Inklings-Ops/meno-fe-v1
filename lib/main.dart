import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' hide ChangeNotifierProvider;
import 'package:meno_fe_v1/src/features/bible/application/scripture_picker/scripture_picker_cubit.dart';
import 'package:meno_fe_v1/src/features/bible/application/verses/verses_cubit.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'src/dependency_injector/injector.dart';
import 'src/features/auth/auth.dart';
import 'src/features/bible/application/bible/bible_bloc.dart';
import 'src/features/bible/application/translations/translations_cubit.dart';
import 'src/features/bible/domain/i_bible_facade.dart';
import 'src/features/network/application/network_cubit.dart';
import 'src/features/onboarding/onboarding.dart';
import 'src/shared/shared.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Flutter Downloader for downloading the Bible translations
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  // Sets the preferred orientation to portrait mode only.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initializes Firebase app with default options for the current platform.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Sets up a background message handler for Firebase Cloud Messaging.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Configures local notifications for the app.
  await setupFlutterNotifications();

  // Configures app-wide dependencies (implementation details not shown).
  await configureDependencies();

  // di<ObjectBoxService>().bibleBox.removeAll();
  // di<ObjectBoxService>().verseBox.removeAll();

  runApp(
    ChangeNotifierProvider(
      create: (context) => di<SessionCubit>(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: di<IAuthFacade>()),
          RepositoryProvider.value(value: di<ISessionContext>()),
          RepositoryProvider.value(value: di<IBroadcastFacade>()),
          RepositoryProvider.value(value: di<IProfileFacade>()),
          RepositoryProvider.value(value: di<IDiscoverFacade>()),
          RepositoryProvider.value(value: di<IBibleFacade>()),
          RepositoryProvider.value(value: LiveKitService()),
          RepositoryProvider.value(value: di<SocketService>()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di<BibleBloc>()..init()),
            BlocProvider(create: (_) => di<SessionCubit>()),
            BlocProvider(create: (_) => di<ScripturePickerCubit>()),
            BlocProvider(create: (_) => di<TranslationsCubit>()..initialize()),
            BlocProvider(create: (_) => di<VersesCubit>()),
            BlocProvider(create: (_) => di<NetworkCubit>()),
            BlocProvider(create: (_) => di<OnboardingCubit>()),
            BlocProvider(create: (_) => di<AccountBloc>()..init()),
            BlocProvider(create: (_) => di<LoginCubit>()),
            BlocProvider(create: (_) => di<RegisterCubit>()),
            BlocProvider(create: (_) => di<MyProfileBloc>()),
            BlocProvider(create: (_) => di<ProfileFormCubit>()),
            BlocProvider(create: (_) => di<MenoBloc>()),
            BlocProvider(create: (_) => TimerCubit()),
            BlocProvider(create: (_) => di<BroadcastFormCubit>()),
            BlocProvider(create: (_) => di<LiveParticipantsBloc>()),
            BlocProvider(create: (_) => di<LiveBroadcastsBloc>()..init()),
            BlocProvider(create: (_) => di<NoteFormCubit>()),
            BlocProvider(create: (_) => di<RecentlyLiveCubit>()..fetch()),
            BlocProvider(create: (_) => di<SearchBloc>()),
            BlocProvider(create: (_) => di<FolderCubit>()),
            BlocProvider(create: (_) => di<DAllCubit>()..init()),
            BlocProvider(create: (_) => di<DNowLiveCubit>()..fetch(1)),
            BlocProvider(create: (_) => di<DRecentlyLiveCubit>()..fetch(1)),
            BlocProvider(create: (_) => di<FilterBloc>()..init()),
            BlocProvider(create: (_) => di<NotesBloc>()..init()),
            BlocProvider(create: (_) => di<FolderFormCubit>()),
            BlocProvider(create: (_) => di<FolderListBloc>()..init()),
            BlocProvider(create: (_) => di<FolderListBloc>()..init()),
            BlocProvider(
              create: (_) => StreamBloc(
                facade: RepositoryProvider.of<IBroadcastFacade>(_),
                liveKit: RepositoryProvider.of<LiveKitService>(_),
                socket: di<SocketService>(),
              ),
            ),
            BlocProvider(
              create: (_) => ChatBloc(
                profileFacade: RepositoryProvider.of<IProfileFacade>(_),
                session: RepositoryProvider.of<ISessionContext>(_),
                socket: di<SocketService>(),
              ),
            ),
            BlocProvider(
              create: (_) => BroadcastBloc(
                facade: RepositoryProvider.of<IBroadcastFacade>(_),
                liveKit: RepositoryProvider.of<LiveKitService>(_),
                socket: di<SocketService>(),
              ),
            ),
          ],
          child: const ProviderScope(child: MenoApp()),
        ),
      ),
    ),
  );
}

// Entry point for handling background messages from Firebase Cloud Messaging.
// This function is marked as an entry point for the VM to ensure it's
// accessible even when the app is in the background.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Future.wait([
    // Initializes Firebase app again, as it might not be running in the background.
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),

    // Requests notification permissions from the user.
    FirebaseMessaging.instance.requestPermission(),

    // Handles the FCM token (implementation details not shown).
    handleFCMToken(),

    // Sets up local notifications for the app.
    setupFlutterNotifications(),
  ]);

  // Displays a Flutter notification based on the received message.
  showFlutterNotification(message);
}

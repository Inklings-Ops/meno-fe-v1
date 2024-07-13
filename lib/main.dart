import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/src/features/bible/application/scripture_picker/scripture_picker_cubit.dart';
import 'package:meno_fe_v1/src/features/bible/application/verses/verses_cubit.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_form/folder_form_cubit.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_list/folder_list_bloc.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'src/dependency_injector/injector.dart';
import 'src/features/auth/application/application.dart';
import 'src/features/bible/application/bible/bible_bloc.dart';
import 'src/features/bible/application/translations/translations_cubit.dart';
import 'src/features/broadcast/application/broadcast/broadcast_bloc.dart';
import 'src/features/broadcast/application/broadcast_form/broadcast_form_cubit.dart';
import 'src/features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart';
import 'src/features/broadcast/application/live_participants/live_participants_bloc.dart';
import 'src/features/broadcast/application/recently_live/recently_live_cubit.dart';
import 'src/features/broadcast/application/stream/stream_bloc.dart';
import 'src/features/broadcast/application/timer/timer_cubit.dart';
import 'src/features/chat/application/chat_bloc.dart';
import 'src/features/network/application/network_cubit.dart';
import 'src/features/notes/application/note_form/note_form_cubit.dart';
import 'src/features/notes/application/notes/notes_bloc.dart';
import 'src/features/onboarding/onboarding.dart';
import 'src/features/profile/application/application.dart';
import 'src/services/meno/meno_bloc.dart';
import 'src/services/notification_service.dart';

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
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di<BibleBloc>()..add(const BibleEvent.initialize()),
        ),
        BlocProvider(create: (_) => di<ScripturePickerCubit>()),
        BlocProvider(create: (_) => di<TranslationsCubit>()..initialize()),
        BlocProvider(create: (_) => di<VersesCubit>()),
        BlocProvider(create: (_) => di<NetworkCubit>()),
        BlocProvider(create: (_) => di<OnboardingCubit>()),
        BlocProvider(create: (_) => di<AuthBloc>()),
        BlocProvider(create: (_) => di<AccountCubit>()..init),
        BlocProvider(create: (_) => di<MyProfileBloc>()),
        BlocProvider(create: (_) => di<ProfileFormCubit>()),
        BlocProvider(create: (_) => di<MenoBloc>()),
        BlocProvider(create: (_) => di<TimerCubit>()),
        BlocProvider(create: (_) => di<BroadcastFormCubit>()),
        BlocProvider(create: (_) => di<StreamBloc>()),
        BlocProvider(create: (_) => di<BroadcastBloc>()),
        BlocProvider(create: (_) => di<ChatBloc>()),
        BlocProvider(create: (_) => di<LiveBroadcastsBloc>()),
        BlocProvider(create: (_) => di<LiveParticipantsBloc>()),
        BlocProvider(create: (_) => di<NoteFormCubit>()),
        BlocProvider(create: (_) => di<RecentlyLiveCubit>()..fetch()),
        BlocProvider(create: (_) => di<SearchBloc>()),
        BlocProvider(create: (_) => di<DAllCubit>()..init()),
        BlocProvider(create: (_) => di<DNowLiveCubit>()..fetch(1)),
        BlocProvider(create: (_) => di<DRecentlyLiveCubit>()..fetch(1)),
        BlocProvider(
          create: (_) => di<FilterBloc>()..add(const FilterFetched(1)),
        ),
        BlocProvider(
          create: (_) => di<NotesBloc>()..add(const NotesEvent.getNotes()),
        ),
        BlocProvider(create: (_) => di<FolderFormCubit>()),
        BlocProvider(
          create: (_) =>
              di<FolderListBloc>()..add(const FolderListEvent.getAllFolders()),
        ),
      ],
      child: const ProviderScope(child: MenoApp()),
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

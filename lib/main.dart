import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'src/dependency_injector/injector.dart';
import 'src/features/auth/application/application.dart';
import 'src/features/broadcast/application/broadcast/broadcast_bloc.dart';
import 'src/features/broadcast/application/broadcast_form/broadcast_form_cubit.dart';
import 'src/features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart';
import 'src/features/broadcast/application/live_participants/live_participants_bloc.dart';
import 'src/features/broadcast/application/recently_live/recently_live_cubit.dart';
import 'src/features/broadcast/application/stream/stream_bloc.dart';
import 'src/features/broadcast/application/timer/timer_cubit.dart';
import 'src/features/network/application/network_cubit.dart';
import 'src/features/onboarding/onboarding.dart';
import 'src/features/profile/application/application.dart';
import 'src/services/meno/meno_bloc.dart';
import 'src/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di<NetworkCubit>()),
        BlocProvider(create: (context) => di<OnboardingCubit>()),
        BlocProvider(create: (context) => di<AuthBloc>()),
        BlocProvider(create: (context) => di<AccountCubit>()..init),
        BlocProvider(create: (context) => di<MyProfileBloc>()),
        BlocProvider(create: (context) => di<ProfileFormCubit>()),
        BlocProvider(create: (context) => di<MenoBloc>()),
        BlocProvider(create: (context) => di<TimerCubit>()),
        BlocProvider(create: (context) => di<BroadcastFormCubit>()),
        BlocProvider(create: (context) => di<StreamBloc>()),
        BlocProvider(create: (context) => di<BroadcastBloc>()),
        BlocProvider(create: (context) => di<RecentlyLiveCubit>()),
        BlocProvider(create: (context) => di<LiveBroadcastsBloc>()),
        BlocProvider(create: (context) => di<LiveParticipantsBloc>()),
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

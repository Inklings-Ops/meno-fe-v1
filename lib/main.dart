import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meno_fe_v1/src/features/network/application/network_cubit.dart';
import 'package:meno_fe_v1/src/features/network/domain/i_network_facade.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'src/dependency_injector/injector.dart';
import 'src/features/auth/domain/i_auth_facade.dart';
import 'src/features/broadcast/domain/i_broadcast_facade.dart';
import 'src/features/notifications/domain/i_notification_facade.dart';
import 'src/features/profile/domain/i_profile_facade.dart';
import 'src/services/notification_service.dart';

Future<void> main() async {
  // Ensures that Flutter bindings are initialized before proceeding.
  WidgetsFlutterBinding.ensureInitialized();

  // Sets the preferred orientation to portrait mode only.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initializes storage for hydrated blocs.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // Initializes Firebase app with default options for the current platform.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Sets up a background message handler for Firebase Cloud Messaging.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Configures local notifications for the app.
  await setupFlutterNotifications();

  // Configures app-wide dependencies (implementation details not shown).
  await configureDependencies();

  // Runs the app within a ProviderScope to manage state using providers.
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => di<IAuthFacade>()),
        RepositoryProvider(create: (context) => di<IBroadcastFacade>()),
        RepositoryProvider(create: (context) => di<INetworkFacade>()),
        RepositoryProvider(create: (context) => di<INotificationFacade>()),
        RepositoryProvider(create: (context) => di<IProfileFacade>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di<NetworkCubit>()),
        ],
        child: const ProviderScope(child: MenoApp()),
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

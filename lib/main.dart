import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meno_fe_v1/app/app.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/services/services.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  await configureDependencies();
  // di<ObjectBoxService>().bibleBox.removeAll();
  // di<ObjectBoxService>().verseBox.removeAll();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => MenoRepositoryProvider(
        child: MenoBlocProvider(
          child: ChangeNotifierProvider(
            create: (ctx) => di<SessionCubit>(),
            child: const MenoApp(),
          ),
        ),
      ),
    ),
  );
  FlutterNativeSplash.remove();
}

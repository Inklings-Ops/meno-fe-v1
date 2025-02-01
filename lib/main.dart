import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:meno_fe_v1/app/app.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  await configureDependencies();
  // Bloc.observer = MenoBlocObserver(log: Logger());

  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => const MenoBlocProvider(
        child: MenoApp(),
      ),
    ),
  );
}

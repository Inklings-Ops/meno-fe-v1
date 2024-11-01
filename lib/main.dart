import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/app/app.dart';
import 'package:meno_fe_v1/app/meno_bloc_observer.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  await configureDependencies();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  Bloc.observer = MenoBlocObserver(log: Logger());
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

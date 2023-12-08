import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'src/dependency_injector/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  // await di<SharedPreferences>().clear();
  // await di<SecureStorageService>().deleteAll();
  runApp(const ProviderScope(child: MenoApp()));
}

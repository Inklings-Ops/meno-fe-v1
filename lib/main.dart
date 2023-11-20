import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'src/dependency_injector/injector.dart';
import 'src/services/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await configureDependencies();
  // await di<SharedPreferences>().clear();
  await di<SecureStorageService>().deleteAll();
  runApp(const ProviderScope(child: MenoApp()));
}

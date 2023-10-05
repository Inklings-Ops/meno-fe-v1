import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/services/secure_storage_service.dart';

import 'app.dart';
import 'injector/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await configureDependencies();
  await di<SecureStorageService>().deleteAll();
  runApp(const ProviderScope(child: MenoApp()));
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'src/dependency_injector/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await configureDependencies();
  // await di<SharedPreferences>().clear();
  // await di<SecureStorageService>().deleteAll();
  runApp(const ProviderScope(child: MenoApp()));
}


/*

Error that is having issue
{"statusCode":400,"message":"You must leave all broadcasts before starting a broadcast","error":"Bad Request","path":"/api/v1/broadcasts/b9f3a815-1a5d-4957-a748-852a105fc68b/start","status":false}


Error from others not having issues
{"message":"Invalid Request","error":{"description":"\"description\" is required"},"path":"/api/v1/broadcasts","status":false,"statusCode":400}
*/
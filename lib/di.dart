import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meno/app/router/router.dart';

void injectDependencies() {
  di.registerLazySingleton(FlutterSecureStorage.new);
  di.registerSingleton(MRouter.new);
}

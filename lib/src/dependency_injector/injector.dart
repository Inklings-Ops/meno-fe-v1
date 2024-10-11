import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:meno_fe_v1/src/dependency_injector/injector.config.dart';

final di = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => di.init();

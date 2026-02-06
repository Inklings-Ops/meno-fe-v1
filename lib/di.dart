import 'package:flutter_it/flutter_it.dart';
import 'package:meno/app/router/router.dart';

void injectDependencies() {
  di.registerSingleton(MRouter.new);
}

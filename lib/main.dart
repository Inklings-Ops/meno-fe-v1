import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meno/app/app.dart';
import 'package:meno/core/di/injector.dart';

/// Entry point for the app.
Future<void> main() async {
  // Keep initial page (splash page)up until DI is ready
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    // Inject the dependencies and wait for them to be ready
    injectDependencies();
    await di.allReady(timeout: const Duration(seconds: 5));

    // Start the app if DI is ready
    runApp(const MenoApp());
  } on Exception catch (error, stack) {
    // FirebaseCrashlytics.instance.recordError(e, stackTrace);
    debugPrint('Error: $error\nStack: $stack');

    // Remove the native splash screen so the error page can be rendered
    FlutterNativeSplash.remove();

    // Run the app with the error widget showing the error
    runApp(MenoAppErrorWidget(error: error, onRetry: main));
  }
}

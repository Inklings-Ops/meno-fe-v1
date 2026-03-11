import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meno/_core/exceptions/global_exception_handler.dart';
import 'package:meno/_di/global_locator.dart';
import 'package:meno/app.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  configureGlobalDependencies();
  configureGlobalExceptionHandler();

  runApp(const MenoApp());
}

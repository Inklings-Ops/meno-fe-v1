import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meno/app/router/router.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MenoApp extends StatefulWidget {
  const MenoApp({super.key});

  @override
  State<MenoApp> createState() => _MenoAppState();
}

class _MenoAppState extends State<MenoApp> {
  @override
  void initState() {
    super.initState();
    // Remove the splash screen once this widget builds.
    // This ensures the remove happens AFTER the first frame is painted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      darkTheme: MTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: di<MRouter>().routerConfig,
      theme: MTheme.light,
    );
  }
}

class MenoAppErrorWidget extends StatelessWidget {
  const MenoAppErrorWidget({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: MTheme.dark,
      theme: MTheme.light,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const MenoText.heading2(
                'Something went wrong',
                weight: MenoFontWeight.bold,
              ),
              const SizedBox(height: 8),
              MenoText.body(
                """
We couldn't start the app. Please check your connection or try again.\n\nError: $error""",
                textAlign: TextAlign.center,
                color: Colors.grey,
              ),
              const SizedBox(height: 32),
              MPrimaryButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: 'Retry Initialization',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

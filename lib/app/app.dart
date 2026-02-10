import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meno/app/router/router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
      routerConfig: di<MenoRouter>().routerConfig,
      theme: MTheme.light,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: PHONE),
          Breakpoint(start: 451, end: 600, name: MOBILE),
          Breakpoint(start: 601, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
        ],
        child: child ?? const SizedBox.shrink(),
      ),
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
      debugShowCheckedModeBanner: false,
      darkTheme: MTheme.dark,
      theme: MTheme.light,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
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

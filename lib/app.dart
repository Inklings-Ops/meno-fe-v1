import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:meno/_core/keys/meno_keys.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/pages/loading_page.dart';
import 'package:meno/_shared/widgets/interaction_connector.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MenoApp extends WatchingWidget {
  const MenoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final snapshot = watchFuture<GetIt, void>(
      (getIt) => getIt.allReady(timeout: const Duration(seconds: 30)),
      target: di,
      initialValue: null,
    );

    if (snapshot.hasError) {
      FlutterNativeSplash.remove();
      return _ErrorWidget(error: snapshot.error, onRetry: di.allReady);
    }

    if (snapshot.connectionState == .waiting) return const _LoadingWidget();

    FlutterNativeSplash.remove();

    // di<LocalStorage>().clearAll();
    // di<SecureStorage>().deleteAll();

    return ValueListenableBuilder(
      valueListenable: di<AuthManager>().activeUserId,
      builder: (context, value, child) {
        return MaterialApp.router(
          darkTheme: MTheme.dark,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [FlutterQuillLocalizations.delegate],
          routerConfig: di<MenoRouter>().routerConfig,
          theme: MTheme.light,
          scaffoldMessengerKey: MenoKeys.scaffoldMessengerKey,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            breakpoints: const [
              Breakpoint(start: 0, end: 450, name: PHONE),
              Breakpoint(start: 451, end: 600, name: MOBILE),
              Breakpoint(start: 601, end: 800, name: TABLET),
              Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
            child: InteractionConnector(child: child),
          ),
        );
      },
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: MTheme.dark,
      theme: MTheme.light,
      scaffoldMessengerKey: MenoKeys.scaffoldMessengerKey,
      home: const LoadingPage(),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.error, this.onRetry});

  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: MTheme.dark,
      theme: MTheme.light,
      scaffoldMessengerKey: MenoKeys.scaffoldMessengerKey,
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

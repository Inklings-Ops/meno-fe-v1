import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:meno/_core/keys/meno_keys.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/pages/loading_page.dart';
import 'package:meno/_shared/widgets/interaction_connector.dart';
import 'package:meno/_shared/widgets/meno_error_widget.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/settings/manager/settings_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:responsive_framework/responsive_framework.dart';

const _kInitTimeout = Duration(seconds: 30);

class MenoApp extends WatchingWidget {
  const MenoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // A ValueNotifier<Future> is the correct retry pattern for watchFuture:
    // replacing the value with a new Future triggers a re-watch because
    // allowFutureChange: true tells watch_it to re-evaluate the select
    // function on every build instead of caching it.
    final futureNotifier = createOnce(
      () => ValueNotifier<Future<void>>(di.allReady(timeout: _kInitTimeout)),
    );

    final snapshot = watchFuture<ValueNotifier<Future<void>>, void>(
      (n) => n.value,
      target: futureNotifier,
      initialValue: null,
      allowFutureChange: true,
    );

    if (snapshot.hasError) {
      FlutterNativeSplash.remove();
      return _ErrorWidget(
        error: snapshot.error,
        onRetry: () async {
          // Swap in a fresh Future — watchFuture detects the change and
          // re-enters the waiting state, giving us a clean retry.
          futureNotifier.value = di.allReady(timeout: _kInitTimeout);
        },
      );
    }

    if (snapshot.connectionState == .waiting) return const _LoadingWidget();

    FlutterNativeSplash.remove();

    final settings = watchValue((SettingsManager m) => m.settings);
    final themeMode = switch (settings.display) {
      .system => ThemeMode.system,
      .dark => ThemeMode.dark,
      .light => ThemeMode.light,
    };

    return ValueListenableBuilder(
      valueListenable: di<AuthManager>().activeUserId,
      builder: (context, userId, _) {
        return MaterialApp.router(
          key: ValueKey(userId),
          themeMode: themeMode,
          darkTheme: MTheme.dark,
          theme: MTheme.light,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [FlutterQuillLocalizations.delegate],
          routerConfig: MenoRouter.instance.config,
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
  const _ErrorWidget({required this.error, required this.onRetry});

  final Object? error;
  final RefreshCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: MTheme.dark,
      theme: MTheme.light,
      scaffoldMessengerKey: MenoKeys.scaffoldMessengerKey,
      home: Scaffold(
        body: Center(
          child: MenoErrorWidget(
            error: error,
            message:
                '''We couldn't start the app. Please check your connection or try again.''',
            onRetry: onRetry,
          ),
        ),
      ),
    );
  }
}

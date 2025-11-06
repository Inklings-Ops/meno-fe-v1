import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meno_app/routing/meno_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_onboarding/meno_onboarding.dart';
import 'package:meno_services/meno_services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.passcode),
  );
  runApp(
    ProviderScope(
      providers: [
        sharedPreferencesProvider(preferences),
        secureStorageProvider(secureStorage),
      ],
      child: ProviderScope(
        providers: [LocalStorageImpl.provider],
        child: ProviderScope(
          providers: [OnboardingController.provider],
          child: MainApp(),
        ),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.builder(
      useShortestSide: true,
      breakpoints: const [
        Breakpoint(start: 0, end: 450, name: PHONE),
        Breakpoint(start: 451, end: 600, name: MOBILE),
        Breakpoint(start: 601, end: 800, name: TABLET),
        Breakpoint(start: 801, end: 1920, name: DESKTOP),
      ],
      child: Builder(
        builder: (context) {
          var designSize = Size(375, 812);
          bool enableScaleText = false;
          bool enableScaleWH = false;

          if (ResponsiveBreakpoints.of(context).largerThan(TABLET)) {
            designSize = const Size(1440, 1024);
            enableScaleText = true;
            enableScaleWH = true;
          }

          return ScreenUtilInit(
            designSize: designSize,
            minTextAdapt: true,
            splitScreenMode: true,
            enableScaleText: () => enableScaleText,
            enableScaleWH: () => enableScaleWH,
            builder: (context, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: menoRouterConfig,
                theme: MTheme.light,
                darkTheme: MTheme.dark,
                builder: (context, child) => child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

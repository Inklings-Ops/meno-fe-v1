import 'package:device_preview/device_preview.dart';
import 'package:meno_fe_v1/app/meno_bloc_listeners.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart'
    show SettingsBloc;

class MenoApp extends StatelessWidget {
  const MenoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((SettingsBloc b) => b.state.themeMode);
    return MaterialApp.router(
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      theme: MTheme.light,
      darkTheme: MTheme.dark,
      themeMode: themeMode,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: PHONE),
          Breakpoint(start: 451, end: 600, name: MOBILE),
          Breakpoint(start: 601, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
        ],
        child: DevicePreview.appBuilder(
          context,
          MenoBlocListeners(child: child),
        ),
      ),
    );
  }
}

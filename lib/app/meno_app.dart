import 'package:device_preview/device_preview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/meno.dart';

class MenoApp extends StatefulWidget {
  const MenoApp({super.key});
  @override
  State<StatefulWidget> createState() => _MenoAppState();
}

class _MenoAppState extends State<MenoApp> {
  late final AppLifecycleListener _listener;
  final toastBuilder = FToastBuilder();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        locale: DevicePreview.locale(context),
        debugShowCheckedModeBanner: false,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        theme: ThemeData(fontFamily: FontFamily.sFProDisplay),
        builder: (context, child) {
          child = toastBuilder(context, child);
          return DevicePreview.appBuilder(context, child);
          // return ResponsiveBreakpoints.builder(
          //   child: child,
          //   breakpoints: const [
          //     Breakpoint(start: 0, end: 450, name: MOBILE),
          //     Breakpoint(start: 451, end: 800, name: TABLET),
          //     Breakpoint(start: 801, end: 1920, name: DESKTOP),
          //   ],
          // );
        },
      ),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onStateChange: _onStateChanged);
  }

  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        di<NetworkCubit>().close();
        break;
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        if (di<NetworkCubit>().isClosed) {
          di<NetworkCubit>();
        }
        break;
    }
  }
}

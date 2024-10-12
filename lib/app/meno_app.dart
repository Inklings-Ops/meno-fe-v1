import 'package:device_preview/device_preview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

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
        theme: MTheme.light,
        darkTheme: MTheme.dark,
        builder: (context, child) {
          child = toastBuilder(context, child);
        
          return ResponsiveBreakpoints.builder(
            breakpoints: const [
              Breakpoint(start: 0, end: 450, name: PHONE),
              Breakpoint(start: 451, end: 600, name: MOBILE),
              Breakpoint(start: 601, end: 800, name: TABLET),
              Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
            child: BlocListener<SessionCubit, SessionState>(
              key: const ValueKey('APP-SessionCubit-Listener'),
              listener: (context, state) => state.whenOrNull(
                authenticated: (user, token) {
                  context.read<AccountBloc>().init();
                  context.read<MyProfileBloc>().init();
                  context.read<NotesBloc>().init();
                  context.read<LiveBroadcastsBloc>().init();
                  context.read<RecentlyLiveCubit>().fetch();
                  return null;
                },
              ),
              child: DevicePreview.appBuilder(context, child),
            ),
          );
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
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        if (di<NetworkCubit>().isClosed) {
          di<NetworkCubit>();
        }
    }
  }
}

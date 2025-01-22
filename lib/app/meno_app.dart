import 'package:device_preview/device_preview.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';

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
    return MaterialApp.router(
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
          child: DevicePreview.appBuilder(context, child),
        );
      },
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
        // App is closed or crashed
        // context.read<NetworkCubit>().close();
        final stream = context.read<StreamBloc>();
        final socket = context.read<SocketBloc>();
        final livekit = context.read<LiveKitBloc>();
        if (stream.state.status is LiveKitStreamConnected ||
            stream.state.status is LiveKitStreamReconnected) {
          di<BackgroundService>().stopBroadcastBackgroundProcess();
          livekit.add(const LiveKitDisconnect());
          socket.add(SocketLeaveBroadcast(stream.state.broadcast.id));
        }
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      // App goes into the background
      // context.read<NetworkCubit>().close();
      case AppLifecycleState.resumed:
      // App is brought back from the background
      // if (context.read<NetworkCubit>().isClosed) {
      //   context.read<NetworkCubit>();
      // }
    }
  }
}

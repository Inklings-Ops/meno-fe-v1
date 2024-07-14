import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
import 'package:meno_fe_v1/src/features/network/application/network_cubit.dart';

import '../src/router/m_router.dart';
import 'meno_wrapper.dart';

class MenoApp extends StatefulWidget {
  const MenoApp({super.key});
  @override
  State<StatefulWidget> createState() => _MenoAppState();
}

class _MenoAppState extends State<MenoApp> {
  late final AppLifecycleListener _listener;

  final toastBuilder = FToastBuilder();
  final routerConfig = MRouter.routerConfig;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (_, child) => MaterialApp.router(
        theme: MTheme.light,
        darkTheme: MTheme.dark,
        debugShowCheckedModeBanner: false,
        routerDelegate: routerConfig.routerDelegate,
        routeInformationParser: routerConfig.routeInformationParser,
        routeInformationProvider: routerConfig.routeInformationProvider,
        builder: (context, child) {
          child = toastBuilder(context, child);
          return MediaQuery(
            data: context.getDirtyData,
            child: Overlay(
              initialEntries: [
                OverlayEntry(builder: (_) => MenoWrapper(child: child)),
              ],
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

extension MediaQueryX on BuildContext {
  MediaQueryData get getDirtyData {
    return MediaQuery.of(this).copyWith(textScaler: TextScaler.linear(1.sp));
  }
}

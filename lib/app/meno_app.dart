import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/dependency_injector/injector.dart';

import '../src/features/network/application/network_cubit.dart';
import '../src/router/m_router.dart';
import 'meno_wrapper.dart';

class MenoApp extends ConsumerStatefulWidget {
  const MenoApp({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenoAppState();
}

class _MenoAppState extends ConsumerState<MenoApp> {
  late final AppLifecycleListener _listener;

  @override
  Widget build(BuildContext context) {
    final toastBuilder = FToastBuilder();
    final router = di<MRouter>().router;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (_, child) => MaterialApp.router(
        theme: MTheme.light,
        darkTheme: MTheme.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        builder: (context, child) {
          child = toastBuilder(context, child);

          return MediaQuery(
            data: context.getDirtyData,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => MenoWrapper(
                    router: router,
                    child: child,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Do not forget to dispose the listener
    _listener.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize the AppLifecycleListener class and pass callbacks
    _listener = AppLifecycleListener(onStateChange: _onStateChanged);
  }

  // Listen to the app lifecycle state changes
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

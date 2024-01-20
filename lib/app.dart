import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/m_toast_extensions.dart';

import 'src/features/network/application/network_cubit.dart';
import 'src/features/network/domain/network_status.dart';
import 'src/router/m_router.dart';

class MenoApp extends ConsumerStatefulWidget {
  const MenoApp({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenoAppState();
}

class _MenoAppState extends ConsumerState<MenoApp> {
  @override
  Widget build(BuildContext context) {
    final toastBuilder = FToastBuilder();
    final mRouter = MRouter();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (_, child) => MaterialApp.router(
        theme: MTheme.light,
        darkTheme: MTheme.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: mRouter.router,
        builder: (context, child) {
          child = toastBuilder(context, child);

          return MediaQuery(
            data: context.getDirtyData,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) {
                    return BlocListener<NetworkCubit, NetworkState>(
                      bloc: context.read<NetworkCubit>(),
                      listenWhen: (p, c) => p.status != c.status,
                      listener: (context, state) {
                        FToast toast = FToast().init(context);
                        switch (state.status) {
                          case NetworkStatus.disconnected:
                            context.showNetworkError(toast);
                            break;
                          case NetworkStatus.connected:
                            context.showNetworkSuccess(toast);
                            context.closeAllToasts;
                            break;
                        }
                      },
                      child: child,
                    );
                  },                                                  
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

extension MediaQueryX on BuildContext {
  MediaQueryData get getDirtyData {
    return MediaQuery.of(this).copyWith(textScaler: TextScaler.linear(1.sp));
  }
}

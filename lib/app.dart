import 'package:auto_route/auto_route.dart';
import 'package:figma_layout_grid/figma_layout_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';
import 'package:meno_fe_v1/features/onboarding/application/onboarding_provider.dart';
import 'package:meno_fe_v1/injector/injector.dart';
import 'package:meno_fe_v1/router/m_observer.dart';
import 'package:meno_fe_v1/router/m_router.dart';

class MenoApp extends ConsumerStatefulWidget {
  const MenoApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenoAppState();
}

class _MenoAppState extends ConsumerState<MenoApp> {
  final _mRouter = MRouter();

  @override
  Widget build(BuildContext context) {
    final authNotifier = di<AuthNotifier>();

    return MaterialApp.router(
      theme: MTheme.light,
      darkTheme: MTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: _mRouter.config(
        navigatorObservers: () => [MObserver()],
        deepLinkBuilder: (deepLink) async {
          if (!ref.read(onboardingProvider).isOnboarded()) {
            return DeepLink([OnboardingRoute()]);
          } else {
            switch (authNotifier.state) {
              case AuthState.partiallyAuthenticated:
                return const DeepLink([ReturnLoginRoute()]);
              case AuthState.unauthenticated:
                return DeepLink([LoginRoute()]);
              default:
                return DeepLink.defaultPath;
            }
          }
        },
      ),
      builder: (context, child) {
        final isLight = Theme.of(context).brightness == Brightness.light;
        final color = isLight ? MColor.white : MColor.primary700;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(systemNavigationBarColor: color),
          child: LayoutGrid(
            rowsParams: const RowsParams(height: 8),
            columnsParams: const ColumnsParams(
              count: 4,
              gutter: 8,
              margin: 16,
            ),
            builder: (context) => child!,
          ),
        );
      },
    );
  }
}

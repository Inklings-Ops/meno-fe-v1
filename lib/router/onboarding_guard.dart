import 'package:auto_route/auto_route.dart';
import 'package:meno_fe_v1/features/onboarding/infrastructure/onboarding_local_datasource.dart';
import 'package:meno_fe_v1/injector/injector.dart';
import 'package:meno_fe_v1/router/m_router.dart';

class OnboardingGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isOnboarded = di<OnboardingLocalDatasource>().isOnboarded();

    if (isOnboarded) {
      resolver.next();
    } else {
      router.replaceAll([OnboardingRoute()]);
    }
  }
}

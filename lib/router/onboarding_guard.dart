import 'package:auto_route/auto_route.dart';
import 'package:meno_fe_v1/features/onboarding/infrastructure/onboarding_local_datasource.dart';
import 'package:meno_fe_v1/router/m_router.dart';
import 'package:meno_fe_v1/services/secure_storage_service.dart';

class OnboardingGuard extends AutoRouteGuard {
  final _source = OnboardingLocalDatasource(storage: SecureStorageService());

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isOnboarded = await _source.isOnboarded();

    if (isOnboarded) {
      resolver.next();
    } else {
      router.replaceAll([const OnboardingRoute()]);
    }
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:meno_fe_v1/features/auth/infrastructure/datasources/auth_local_datasource.dart';
import 'package:meno_fe_v1/router/m_router.dart';
import 'package:meno_fe_v1/services/secure_storage_service.dart';

class AuthGuard extends AutoRouteGuard {
  final _source = AuthLocalDatasource(storage: SecureStorageService());

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isLoggedIn = await _source.isLoggedIn();

    if (isLoggedIn || resolver.route.name == LoginRoute.name) {
      resolver.next();
    } else {
      resolver.redirect(LoginRoute(onLogin: (v) => resolver.next(v)));
    }
  }
}

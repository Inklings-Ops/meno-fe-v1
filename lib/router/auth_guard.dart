// import 'package:auto_route/auto_route.dart';
// import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';
// import 'package:meno_fe_v1/injector/injector.dart';
// import 'package:meno_fe_v1/router/m_router.dart';

// class AuthGuard extends AutoRouteGuard {
//   final authNotifier = di<AuthNotifier>();
//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) {
//     if (authNotifier.isAuthenticated) {
//       resolver.next(true);
//     } else {
//       router.replaceAll([
//         LoginRoute(onLogin: (value) {
//           authNotifier.isAuthenticated = value;
//           router.markUrlStateForReplace();
//           router.removeLast();
//           resolver.next();
//         })
//       ]);
//     }
//   }
// }

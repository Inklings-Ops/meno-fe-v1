// 
// import 'package:figma_layout_grid/figma_layout_grid.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:meno_design_system/meno_design_system.dart';
// import 'package:meno_fe_v1/src/services/socket_service/socket_service.dart';
// import 'package:responsive_framework/responsive_framework.dart';

// import 'src/features/auth/application/application.dart';
// import 'src/features/onboarding/onboarding.dart';
// import 'src/router/router.dart';

// class MenoApp extends ConsumerStatefulWidget {
//   const MenoApp({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _MenoAppState();
// }

// class _MenoAppState extends ConsumerState<MenoApp> {
//   final _mRouter = MRouter();

//   @override
//   Widget build(BuildContext context) {
//     final authStatus = ref.watch(authProvider).status;

//     return MaterialApp.router(
//       theme: MTheme.light,
//       darkTheme: MTheme.dark,
//       debugShowCheckedModeBanner: false,
//       routerConfig: _mRouter.config(
//         deepLinkBuilder: (deepLink) async {
//           if (!ref.read(onboardingProvider).isOnboarded()) {
//             return DeepLink([OnboardingRoute()]);
//           } else {
//             switch (authStatus) {
//               case AuthStatus.partiallyAuthenticated:
//                 return DeepLink([LoginRoute(isPasswordOnly: true)]);
//               case AuthStatus.authenticated:
//                 ref.watch(socketServiceProvider.notifier);
//                 return DeepLink.defaultPath;
//               default:
//                 return DeepLink([LoginRoute()]);
//             }
//           }
//         },
//       ),
//       builder: (context, child) {
//         final isLight = Theme.of(context).brightness == Brightness.light;
//         final color = isLight ? MColor.white : MColor.primary700;
//         return ResponsiveBreakpoints.builder(
//           breakpoints: [
//             const Breakpoint(start: 0, end: 450, name: MOBILE),
//             const Breakpoint(start: 451, end: 800, name: TABLET),
//             const Breakpoint(start: 801, end: 1920, name: DESKTOP),
//             const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
//           ],
//           child: AnnotatedRegion<SystemUiOverlayStyle>(
//             value: SystemUiOverlayStyle(systemNavigationBarColor: color),
//             child: LayoutGrid(
//               rowsParams: const RowsParams(height: 8),
//               columnsParams: const ColumnsParams(
//                 count: 4,
//                 gutter: 8,
//                 margin: 16,
//               ),
//               builder: (context) => child!,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

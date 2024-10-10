// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// 
// import 'package:meno_fe_v1/src/shared/pages/loading_page.dart';

// import '../../../features/auth/application/application.dart';
// import '../../../features/onboarding/onboarding.dart';
// import '../../../router/router.dart';

// class StartupPage extends StatefulWidget {
//   const StartupPage({super.key});

//   @override
//   State<StartupPage> createState() => _StartupPageState();
// }

// class _StartupPageState extends State<StartupPage> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         final authBloc = context.read<AuthBloc>();
//         final onboardingCubit = context.read<OnboardingCubit>();

//         if (onboardingCubit.state == OnboardingState.notCompleted) {
//           return router.go(Routes.onboarding);
//         } else {
//           authBloc.state.when(
//             authenticated: (_) => router.go(Routes.home),
//             unauthenticated: () => router.go(Routes.login),
//             partiallyAuthenticated: (user) => router.go(Routes.partialLogin),
//           );
//         }
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<AuthBloc, AuthState>(
//           bloc: context.watch<AuthBloc>(),
//           listenWhen: (p, c) => p != c,
//           listener: (context, state) {
//             state.when(
//               authenticated: (_) => router.go(Routes.home),
//               unauthenticated: () => router.go(Routes.login),
//               partiallyAuthenticated: (_) => router.go(Routes.partialLogin),
//             );
//           },
//         ),
//       ],
//       child: const LoadingPage(),
//     );
//   }
// }

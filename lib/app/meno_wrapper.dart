// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:meno_fe_v1/src/shared/extensions/m_toast_extensions.dart';

// import '../src/features/network/application/network_cubit.dart';
// import '../src/features/network/domain/network_status.dart';

// class MenoWrapper extends StatelessWidget {
//   const MenoWrapper({super.key, required this.child});
//   final Widget? child;

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<NetworkCubit, NetworkState>(
//           bloc: context.read<NetworkCubit>(),
//           listenWhen: (p, c) => p.status != c.status,
//           listener: (context, state) {
//             FToast toast = FToast().init(context);
//             switch (state.status) {
//               case NetworkStatus.disconnected:
//                 context.showNetworkError(toast);
//                 break;
//               case NetworkStatus.connected:
//                 context.showNetworkSuccess(toast);
//                 context.closeAllToasts;
//                 break;
//             }
//           },
//         ),
//         // BlocListener<AuthBloc, AuthState>(
//         //   listenWhen: (p, c) => p != c,
//         //   listener: (context, state) {
//         //     state.whenOrNull(
//         //       authenticated: (_) => router.go(Routes.home),
//         //       unauthenticated: () => router.go(Routes.login),
//         //       partiallyAuthenticated: (credential) {
//         //         di<LoginCubit>().emailChanged(credential.user.email.getOr());
//         //         router.go(Routes.partialLogin);
//         //       },
//         //     );
//         //   },
//         // ),
//       ],
//       child: DevicePreview.appBuilder(context, child),
//     );
//   }
// }

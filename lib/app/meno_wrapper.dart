import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_fe_v1/src/shared/extensions/m_toast_extensions.dart';

import '../src/features/auth/application/auth/auth_bloc.dart';
import '../src/features/network/application/network_cubit.dart';
import '../src/features/network/domain/network_status.dart';
import '../src/router/router.dart';

class MenoWrapper extends StatelessWidget {
  final Widget? child;
  final GoRouter router;

  const MenoWrapper({
    super.key,
    required this.child,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<NetworkCubit, NetworkState>(
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
        ),
        BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (p, c) => p != c,
          listener: (context, state) {
            state.when(
              authenticated: (_) => router.go(Routes.home),
              unauthenticated: () => router.go(Routes.login),
              partiallyAuthenticated: (_) => router.go(Routes.partialLogin),
            );
          },
        ),
      ],
      child: child!,
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../router/router.dart';
import '../../../auth/application/application.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MText("Home"),
            20.verticalSpace,
            MSecondaryButton.icon(
              label: "Logout",
              icon: const Icon(MIcons.log_out),
              loading: ref.watch(authProvider).loading,
              onPressed: () {
                context.router.pushAndPopUntil(
                  LoginRoute(isPasswordOnly: true),
                  predicate: (route) => false,
                );
                ref.read(authProvider.notifier).partialLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

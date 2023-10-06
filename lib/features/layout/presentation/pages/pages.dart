import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';

import 'package:meno_fe_v1/router/m_router.dart';

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
                ref.read(authProvider.notifier).partialLogout();
                context.router.replaceAll([const ReturnLoginRoute()]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: MText("Discover")),
    );
  }
}

@RoutePage()
class CreateBroadcastPage extends StatelessWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: MText("Create Broadcast")),
    );
  }
}

@RoutePage()
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: MText("Notes")),
    );
  }
}

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: MText("Profile")),
    );
  }
}

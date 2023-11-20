import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/application.dart';

import '../../../dependency_injector/injector.dart';
import '../../../services/secure_storage_service.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: MText("Discover")),
    );
  }
}

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: MText("Notes")),
    );
  }
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MText("Profile"),
            const SizedBox(height: 24),
            MPrimaryButton.icon(
              label: "Logout",
              icon: const Icon(MIcons.log_out),
              onPressed: ref.read(authProvider.notifier).partialLogout,
            ),
            const SizedBox(height: 24),
            MDangerButton.icon(
              label: "Clear Cache",
              icon: const Icon(MIcons.log_out),
              onPressed: () async {
                await di<SecureStorageService>().deleteAll();
                await ref.read(authProvider.notifier).checkAuthenticated();
              },
            ),
          ],
        ),
      ),
    );
  }
}

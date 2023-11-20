import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../router/router.dart';
import '../../../services/socket/socket_service.dart';
import '../../../shared/constants/m_bottom_navigation_bar_items.dart';

class MLayout extends HookConsumerWidget {
  final StatefulNavigationShell shell;

  const MLayout({
    Key? key,
    required this.shell,
  }) : super(key: key ?? const ValueKey<String>('MLayout'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(socketServiceProvider);

    return Scaffold(
      body: shell,
      bottomNavigationBar: MBottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: shell.currentIndex,
        onTap: (index) => shell.goBranch(
          index,
          initialLocation: index == shell.currentIndex,
        ),
        customItem: MBottomBarNavigationItem(
          selected: false,
          onTap: () => context.push(Routes.createBroadcast),
          customItem: const Microphone(),
        ),
      ),
    );
  }
}

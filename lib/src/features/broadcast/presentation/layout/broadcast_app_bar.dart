import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// Custom AppBar for the live session, including tabs and a chat
/// notification dot.
class BroadcastAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an BroadcastAppBar.
  const BroadcastAppBar({
    required this.controller,
    required this.showChatDot,
    this.onTabChanged,
    super.key,
  });

  final TabController controller;
  final void Function(int)? onTabChanged;
  final bool showChatDot;

  @override
  Widget build(BuildContext context) {
    Widget icon = const SizedBox.shrink();
    if (showChatDot) {
      icon = Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      );
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        child: MTabBar.normal(
          controller: controller,
          onTap: onTabChanged,
          tabs: [
            const MenoTab(text: 'Broadcast'),
            MenoTab(text: 'Chat', icon: icon),
            const MenoTab(text: 'Live Bible'),
            const MenoTab(text: 'Live Notes'),
          ],
          padding: EdgeInsets.zero,
          isScrollable: false,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

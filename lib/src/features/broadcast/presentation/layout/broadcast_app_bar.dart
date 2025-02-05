import 'package:meno_fe_v1/meno.dart';

class BroadcastAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BroadcastAppBar({required this.controller, this.onTabTap, super.key});

  final TabController controller;
  final void Function(int)? onTabTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        constraints: const BoxConstraints(minHeight: 32),
        child: TabBar(
          controller: controller,
          onTap: onTabTap,
          tabs: const [
            Tab(text: 'Broadcast'),
            Tab(text: 'Chat'),
            Tab(text: 'Live Bible'),
            Tab(text: 'Live Notes'),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

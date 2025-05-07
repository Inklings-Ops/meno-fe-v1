import 'package:meno_fe_v1/meno.dart';

class BroadcastAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BroadcastAppBar({
    required this.controller,
    this.onTabTap,
    super.key,
    this.showChatDot = false,
  });

  final TabController controller;
  final void Function(int)? onTabTap;
  final bool showChatDot;

  @override
  Widget build(BuildContext context) {
    final dangerColor = MColorScheme.of(context).error;
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        constraints: const BoxConstraints(minHeight: 32),
        child: TabBar(
          controller: controller,
          onTap: onTabTap,
          tabs: [
            const Tab(text: 'Broadcast'),
            Tab(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (showChatDot)
                    Positioned(
                      left: -8,
                      child: MDot(color: dangerColor),
                    ),
                  const Text('Chat'),
                ],
              ),
            ),
            const Tab(text: 'Live Bible'),
            const Tab(text: 'Live Notes'),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

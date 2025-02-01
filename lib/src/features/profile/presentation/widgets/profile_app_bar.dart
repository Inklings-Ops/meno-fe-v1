import 'package:meno_fe_v1/meno.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({required this.name, super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return AppBar(
      leading: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: ColoredBox(
            color: colors.secondary!,
            child: const SizedBox(height: 30, width: 3),
          ),
        ),
      ),
      titleTextStyle: textTheme.heading3Bold,
      leadingWidth: 23,
      titleSpacing: 0,
      title: GestureDetector(
        onTap: () => router.push(Routes.switchAccountModal),
        child: Row(
          children: [
            MText(name, color: colors.onBackground),
            Spaces.horizontalSmall,
            const Icon(MIcons.chevron_down, size: 24),
          ],
        ),
      ),
      actions: [
        MIconButton(
          icon: const Icon(MIcons.settings),
          color: colors.primary,
        ),
        Spaces.horizontalLarge,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

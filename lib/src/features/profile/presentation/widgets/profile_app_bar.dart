import 'package:meno_fe_v1/meno.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return AppBar(
      leading: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16).radius,
          child: ColoredBox(
            color: colors.secondary!,
            child: SizedBox(height: 30.toScale, width: 3.toScale),
          ),
        ),
      ),
      titleTextStyle: $styles.text.heading3Bold,
      leadingWidth: 23.toScale,
      titleSpacing: 0,
      title: GestureDetector(
        onTap: () => context.showSwitchAccountSheet(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MText(name, color: colors.onBackground),
            $styles.spaces.horizontalSmall,
            Icon(MIcons.chevron_down, size: 24.toScale),
          ],
        ),
      ),
      actions: [
        MIconButton(
          icon: const Icon(MIcons.settings),
          color: colors.primary,
        ),
        $styles.spaces.horizontalLarge,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.toScale);
}

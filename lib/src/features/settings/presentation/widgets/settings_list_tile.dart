import 'package:meno_fe_v1/meno.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    required this.title,
    required this.leadingIcon,
    required this.onTap,
    super.key,
    this.isDisabled = false,
    this.trailing,
    this.showDivider = true,
    this.titleColor,
    this.iconColor,
  });

  final String title;
  final IconData leadingIcon;
  final bool isDisabled;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showDivider;
  final MColor? titleColor;
  final MColor? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return Column(
      children: [
        ListTile(
          tileColor: resolveDisabledWithOpacity(colors.surfaceTint),
          onTap: isDisabled ? null : onTap,
          minTileHeight: 56,
          leading: Icon(
            leadingIcon,
            size: 20,
            color: iconColor ?? resolveDisabledWithOpacity(colors.primary),
          ),
          horizontalTitleGap: Insets.sm,
          title: MText(
            title,
            style: textTheme.captionMedium,
            color: titleColor ??
                resolveDisabled(colors.onBackground, colors.onInActive),
          ),
          trailing: trailing ??
              Icon(
                MIcons.chevron_right,
                size: 20,
                color: resolveDisabledWithOpacity(colors.onBackgroundVariant),
              ),
        ),
        if (showDivider) const MDivider(),
      ],
    );
  }

  MColor? resolveDisabled(MColor? main, MColor? disabled) {
    return !isDisabled ? main : disabled;
  }

  Color? resolveDisabledWithOpacity(Color? color) {
    return !isDisabled ? color : color?.withValues(alpha: 0.5);
  }
}

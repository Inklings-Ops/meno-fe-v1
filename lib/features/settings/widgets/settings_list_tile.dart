import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    required this.title,
    super.key,
    this.leadingIcon,
    this.onTap,
    this.isDisabled = false,
    this.trailing,
    this.showDivider = true,
    this.titleColor,
    this.iconColor,
  });

  final String title;
  final IconData? leadingIcon;
  final bool isDisabled;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color? titleColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final effectiveTextColor =
        titleColor ?? resolveDisabled(colors.onBackground, colors.onInActive);

    Widget? leadingWidget;
    if (leadingIcon != null) {
      leadingWidget = Icon(
        leadingIcon,
        size: 20,
        color: iconColor ?? resolveDisabledWithOpacity(colors.primary),
      );
    }

    return Column(
      children: [
        ListTile(
          tileColor: resolveDisabledWithOpacity(colors.surfaceTint),
          onTap: isDisabled ? null : onTap,
          minTileHeight: 56,
          leading: leadingWidget,
          horizontalTitleGap: Insets.sm,
          contentPadding: const .symmetric(horizontal: Insets.lg),
          title: MText(
            title,
            style: textTheme.captionMedium,
            color: effectiveTextColor,
          ),
          trailing:
              trailing ??
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

  Color? resolveDisabled(Color? main, Color? disabled) {
    return !isDisabled ? main : disabled;
  }

  Color? resolveDisabledWithOpacity(Color? color) {
    return !isDisabled ? color : color?.withValues(alpha: 0.5);
  }
}

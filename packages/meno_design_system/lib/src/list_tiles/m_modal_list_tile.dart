import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MModalListTile extends StatelessWidget {
  const MModalListTile({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.showDivider = false,
    this.onTap,
    this.titleColor,
  });
  final String? title;
  final Widget? leading;
  final IconData? trailing;
  final bool showDivider;
  final VoidCallback? onTap;
  final MColor? titleColor;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final iconTheme = IconThemeData(
      size: 20.toScale,
      color: titleColor ?? colors.onBackground,
    );

    return SizedBox(
      height: showDivider ? 56.0.toScale : null,
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            minTileHeight: 40.toScale,
            title: title != null
                ? MText(
                    title!,
                    style: $styles.text.bodyRegular,
                    color: titleColor,
                  )
                : null,
            minLeadingWidth: $styles.insets.medium,
            leading: IconTheme(
              data: iconTheme,
              child: SizedBox.square(dimension: 24.toScale, child: leading),
            ),
            trailing: SizedBox.square(
              dimension: 24.toScale,
              child: trailing != null
                  ? IconTheme(data: iconTheme, child: Icon(trailing))
                  : null,
            ),
            contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0).radius,
          ),
          if (showDivider)
            MDivider(
              bottomSpace: $styles.insets.small,
              topSpace: $styles.insets.small,
            ),
        ],
      ),
    );
  }
}

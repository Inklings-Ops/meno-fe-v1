import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../m_core.dart';

class MModalListTile extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final IconData? trailing;
  final bool showDivider;
  final VoidCallback? onTap;
  final MColor? titleColor;

  const MModalListTile({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.showDivider = false,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final IconThemeData iconTheme = IconThemeData(
      size: 20,
      color:titleColor?? colorScheme.onBackground,
    );

    return SizedBox(
      height: showDivider ? 56.0 : null,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListTile(
              onTap: onTap,
              title: title != null
                  ? MText(
                      title!,
                      style: MTextStyle.bodyRegular,
                      color: titleColor,
                    )
                  : null,
              minLeadingWidth: MCore.medium,
              leading: IconTheme(
                data: iconTheme,
                child: SizedBox.square(dimension: 24, child: leading),
              ),
              trailing: SizedBox.square(
                dimension: 24,
                child: trailing != null
                    ? IconTheme(data: iconTheme, child: Icon(trailing))
                    : null,
              ),
              contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            ),
          ),
          if (showDivider)
            const MDivider(bottomSpace: MCore.small, topSpace: MCore.small),
        ],
      ),
    );
  }
}

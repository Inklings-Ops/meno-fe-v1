import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? actionTitle;
  final VoidCallback? action;

  const MHeader({
    super.key,
    required this.title,
    this.actionTitle,
    this.action,
  }) : assert((action != null && actionTitle != null) ||
            (action == null && actionTitle == null));

  @override
  Widget build(BuildContext context) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;
    return Padding(
      padding: MediaQuery.viewPaddingOf(context),
      child: Container(
        color: colorScheme.background,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 3,
              margin: const EdgeInsets.symmetric(vertical: 2),
              color: colorScheme.error,
            ),
            MSize.horizontalSpaceMicro,
            MText(title, style: MTextStyle.heading3Bold),
            const Spacer(),
            if (actionTitle != null && action != null)
              InkWell(
                onTap: action,
                child: MText(actionTitle!, color: colorScheme.primary),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}

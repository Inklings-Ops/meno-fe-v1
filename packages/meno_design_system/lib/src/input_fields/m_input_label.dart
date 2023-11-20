import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MInputLabel extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool required;

  const MInputLabel(this.label, {super.key, this.icon, this.required = false});

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context)!;

    return SizedBox(
      height: 18,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: styles.iconColor),
            const SizedBox(width: 6),
          ],
          MText(label, color: styles.textColor, style: styles.labelTextStyle),
          if (required) ...[
            const SizedBox(width: 6),
            MText("*", color: styles.errorColor, style: styles.labelTextStyle),
          ],
        ],
      ),
    );
  }
}

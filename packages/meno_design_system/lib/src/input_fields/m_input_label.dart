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
    final effectiveGap = 6.vSpace;
    return SizedBox(
      height: 18.toScale,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: $styles.insets.large, color: styles.iconColor),
            effectiveGap,
          ],
          MText(label, color: styles.textColor, style: styles.labelTextStyle),
          if (required) ...[
            effectiveGap,
            MText("*", color: styles.errorColor, style: styles.labelTextStyle),
          ],
        ],
      ),
    );
  }
}

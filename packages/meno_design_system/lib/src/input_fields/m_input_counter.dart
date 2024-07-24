import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MInputCounter extends StatelessWidget {
  const MInputCounter({
    super.key,
    required this.maxLength,
    required this.currentLength,
    this.enabled = true,
  });
  final int maxLength;
  final int currentLength;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context)!;

    final backgroundColor =
        enabled ? styles.counterBgColor : styles.counterBgColorDisabled;

    final textColor =
        enabled ? styles.counterTextColor : styles.counterTextColorDisabled;

    return Container(
      constraints: const BoxConstraints(minWidth: 50, maxHeight: 24).radius,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4).radius,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: $styles.radius.small,
      ),
      child: MText(
        '$currentLength/$maxLength',
        textAlign: TextAlign.right,
        color: textColor,
        style: styles.counterTextStyle,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MInputCounter extends StatelessWidget {
  final int maxLength;
  final int currentLength;
  final bool enabled;

  const MInputCounter({
    super.key,
    required this.maxLength,
    required this.currentLength,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context)!;

    final backgroundColor =
        enabled ? styles.counterBgColor : styles.counterBgColorDisabled;

    final textColor =
        enabled ? styles.counterTextColor : styles.counterTextColorDisabled;

    return Container(
      constraints: const BoxConstraints(minWidth: 50, maxHeight: 24),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: MDimensions.smallBorderRadius,
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

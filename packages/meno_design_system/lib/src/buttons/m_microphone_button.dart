import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MMicrophoneButton extends StatelessWidget {
  final bool isMuted;

  final VoidCallback? onTap;
  const MMicrophoneButton({super.key, this.isMuted = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return MIconButton(
      icon: isMuted
          ? const Icon(MIcons.microphone_off)
          : const Icon(MIcons.microphone),
      color: colorScheme.primary,
      isFilled: true,
      iconSize: 20,
      fillColor: colorScheme.primary?.withOpacity(0.1),
      onPressed: onTap,
    );
  }
}

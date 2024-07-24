import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MMicrophoneButton extends StatelessWidget {
  const MMicrophoneButton({super.key, this.isMuted = true, this.onTap});
  final bool isMuted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return MIconButton(
      icon: isMuted
          ? const Icon(MIcons.microphone_off)
          : const Icon(MIcons.microphone),
      color: colors.primary,
      isFilled: true,
      iconSize: 20.toScale,
      size: 40.toScale,
      fillColor: colors.primary?.withOpacity(0.1),
      onPressed: onTap,
    );
  }
}

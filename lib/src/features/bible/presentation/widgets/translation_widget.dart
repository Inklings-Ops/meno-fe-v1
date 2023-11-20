import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class TranslationWidget extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  const TranslationWidget({super.key, required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return ListTile(
      title: MText(name),
      titleTextStyle: MTextStyle.bodyMedium,
      subtitle: const MText("New Living Translation"),
      subtitleTextStyle: MTextStyle.microRegular,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      tileColor: colorScheme.outlineVariant2,
      minVerticalPadding: MCore.medium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      onTap: onTap,
    );
  }
}

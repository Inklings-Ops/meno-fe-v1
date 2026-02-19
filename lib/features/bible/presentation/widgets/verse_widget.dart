import 'package:flutter/material.dart';
import 'package:meno/features/bible/domain/domain.dart';
import 'package:meno_design_system/meno_design_system.dart';

class VerseWidget extends StatelessWidget {
  const VerseWidget({
    required this.verse,
    this.isSelected = false,
    super.key,
    this.onLongPress,
    this.onTap,
  });

  final Verse verse;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final reference = '${verse.book} ${verse.chapter}:${verse.verse}';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: isSelected ? const EdgeInsets.all(8) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryContainer : Colors.transparent,
          borderRadius: Corners.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: Corners.circle,
                color: isSelected ? colors.primary : colors.primaryContainer,
              ),
              child: MText(
                reference,
                color: isSelected ? colors.onPrimary : null,
                style: textTheme.microMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Spaces.verticalMicro,
            MText(verse.text, style: textTheme.bodyRegular),
          ],
        ),
      ),
    );
  }
}

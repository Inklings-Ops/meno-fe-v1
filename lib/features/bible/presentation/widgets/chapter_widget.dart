import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChapterWidget extends StatelessWidget {
  const ChapterWidget({required this.chapter, super.key});

  final int chapter;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    const borderRadius = Corners.sm;

    return InkWell(
      onTap: () {},
      borderRadius: borderRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: colors.outlineVariant1.withValues(alpha: 0.5),
        ),
        child: MText('$chapter'),
      ),
    );
  }
}

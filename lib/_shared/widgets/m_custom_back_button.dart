import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MCustomBackButton extends StatelessWidget {
  const MCustomBackButton({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Container(
      width: 56,
      height: 18,
      padding: const EdgeInsets.only(left: 16),
      child: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Row(
          children: [
            const Icon(MIcons.chevron_left, size: 16),
            Spaces.horizontalMicro,
            MText(title, style: textTheme.captionMedium),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastTitleWidget extends StatelessWidget {
  const BroadcastTitleWidget({
    required this.title,
    this.maxLines = 2,
    super.key,
  });

  final String title;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: MText(
        title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: textTheme.subheadingBold,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

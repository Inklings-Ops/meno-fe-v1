import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class GoogleDivider extends StatelessWidget {
  const GoogleDivider({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Row(
      children: [
        const Expanded(child: MDivider()),
        Spaces.horizontalSmall,
        MText(title, style: textTheme.microRegular),
        Spaces.horizontalSmall,
        const Expanded(child: MDivider()),
      ],
    );
  }
}

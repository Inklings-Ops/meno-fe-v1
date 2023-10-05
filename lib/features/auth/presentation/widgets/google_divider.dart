import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class GoogleDivider extends StatelessWidget {
  final String title;
  const GoogleDivider({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: MDivider()),
        MSize.horizontalSpaceSmall,
        MText(title, style: MTextStyle.microRegular),
        MSize.horizontalSpaceSmall,
        const Expanded(child: MDivider()),
      ],
    );
  }
}

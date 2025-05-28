import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ProfileStatItem extends StatelessWidget {
  const ProfileStatItem({
    required this.title, super.key,
      this.count= 0,
  });

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return SizedBox(
      height: 46,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MText(count.toString(), style: textTheme.heading3Medium),
          MText(
            title,
            style: textTheme.microMedium,
            color: colorScheme.onBackgroundVariant,
          ),
        ],
      ),
    );
  }
}

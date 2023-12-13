import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ProfileStatItem extends StatelessWidget {
  const ProfileStatItem({
    super.key,
    required this.title,
      this.count= 0,
  });

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return SizedBox(
      height: 46.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MText(count.toString(), style: MTextStyle.heading3Medium),
          MText(
            title,
            style: MTextStyle.microMedium,
            color: colorScheme.onBackgroundVariant,
          ),
        ],
      ),
    );
  }
}

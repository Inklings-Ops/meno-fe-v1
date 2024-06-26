import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MNotesBackButton extends StatelessWidget {
  const MNotesBackButton({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 18.h,
      padding: const EdgeInsets.only(left: MCore.large).r,
      child: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Row(
          children: [
            Icon(MIcons.chevron_left, size: 16.r),
            MCore.micro.horizontalSpace,
              MText(title, style: MTextStyle.captionMedium),
          ],
        ),
      ),
    );
  }
}

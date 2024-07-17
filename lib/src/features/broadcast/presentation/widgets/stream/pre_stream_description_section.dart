import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class PreStreamDescriptionSection extends StatelessWidget {
  const PreStreamDescriptionSection({super.key, required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(MIcons.menu_03, size: 16.r),
            MCore.small.horizontalSpace,
            const MText('Description', style: MTextStyle.subheadingMedium),
          ],
        ),
        MCore.large.verticalSpace,
        if (broadcast.description?.getOr() != null)
          MText(broadcast.description!.getOr()!),
      ],
    );
  }
}

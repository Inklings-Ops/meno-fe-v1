import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveNotificationCard extends StatelessWidget {
  const LiveNotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;

    return Container(
      padding: styles.nCardContentPadding,
      decoration: ShapeDecoration(
        color: styles.nBackgroundColor,
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.5),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MBadge.small(),
          MCore.small.horizontalSpace,
          const MAvatar(radius: 24),
          MCore.small.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  "The Upper Room Fellowship published: Inferno: Wild Fire (Acts 19:20)",
                  style: styles.nTitleTextStyle,
                  maxLines: 4,
                ),
                14.verticalSpace,
                MText(
                  "Just now",
                  style: styles.nSubtitleTextStyle,
                  color: styles.nSubtitleColor,
                ),
              ],
            ),
          ),
          MCore.small.horizontalSpace,
          Container(
            height: 80.h,
            width: 88.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12).r,
              border: Border.all(),
              // image: DecorationImage(
              //   image: AssetImage(Assets.images.celebrate.path),
              // ),
            ),
            child: Center(child: MPlaceholder(dimension: 30.r)),
          ),
          MCore.small.horizontalSpace,
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: MIconButton(
              icon: Icon(MIcons.dots_vertical, size: 16.r),
            ),
          ),
        ],
      ),
    );
  }
}

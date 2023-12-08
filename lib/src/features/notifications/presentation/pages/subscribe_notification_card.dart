import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class SubscribeNotificationCard extends StatelessWidget {
  const SubscribeNotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;

    return Container(
      padding: styles.nCardContentPadding,
      decoration: BoxDecoration(
        color: styles.backgroundColor,
        borderRadius: styles.nBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MAvatar(radius: 24),
          MCore.small.horizontalSpace,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  "Kelechi Oguike just subscribed to you",
                  style: styles.nTitleTextStyle,
                  maxLines: 2,
                ),
                MCore.small.verticalSpace,
                MText(
                  "3 days ago",
                  style: styles.nSubtitleTextStyle,
                  color: styles.nSubtitleColor,
                ),
              ],
            ),
          ),
          MCore.small.horizontalSpace,
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 16.w,
              height: 16.w,
              child: MIconButton(
                icon: Icon(MIcons.dots_vertical, size: 16.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

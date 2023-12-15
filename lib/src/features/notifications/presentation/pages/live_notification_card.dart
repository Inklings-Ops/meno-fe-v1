import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/helpers/date_helpers.dart';

import '../../domain/entities/notification.dart';

class LiveNotificationCard extends StatelessWidget {
  const LiveNotificationCard({super.key, required this.notification});

  final Notification notification;

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
                  notification.content.title!,
                  style: styles.nTitleTextStyle,
                  maxLines: 4,
                ),
                14.verticalSpace,
                MText(
                  DateHelpers.calculateTimeAgo(notification.createdAt),
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
              image: notification.content.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(notification.content.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
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

import 'package:flutter/material.dart' hide Notification;
import 'package:meno/features/notifications/domain/entities/notification.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:timeago/timeago.dart' as timeago;

class LiveNotificationCard extends StatelessWidget {
  const LiveNotificationCard({required this.notification, super.key});

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context);
    return Container(
      padding: styles.nCardContentPadding,
      decoration: ShapeDecoration(
        color: styles.nBackgroundColor,
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadiusGeometry.all(.circular(Insets.lg)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MBadge.small(),
          Spaces.horizontalSmall,
          const MAvatar(radius: 24),
          Spaces.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  notification.content!.title!,
                  style: styles.nTitleTextStyle,
                  maxLines: 4,
                ),
                if (notification.createdAt != null) ...[
                  const SizedBox(height: 14),
                  MText(
                    timeago.format(notification.createdAt!),
                    style: styles.nSubtitleTextStyle,
                    color: styles.nSubtitleColor,
                  ),
                ],
              ],
            ),
          ),
          Spaces.horizontalSmall,
          Container(
            height: 80,
            width: 88,
            decoration: BoxDecoration(
              borderRadius: Corners.md,
              border: Border.all(),
              image: notification.content?.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(notification.content!.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: const Center(child: MPlaceholder(dimension: 30)),
          ),
          Spaces.horizontalSmall,
          const SizedBox.square(
            dimension: 16,
            child: MIconButton(icon: Icon(MIcons.dots_vertical, size: 16)),
          ),
        ],
      ),
    );
  }
}

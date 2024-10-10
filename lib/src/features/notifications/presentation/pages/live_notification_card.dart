import 'package:figma_squircle/figma_squircle.dart';
import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

class LiveNotificationCard extends StatelessWidget {
  const LiveNotificationCard({required this.notification, super.key});
  final Notification notification;

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;
    return Container(
      padding: styles.nCardContentPadding,
      decoration: ShapeDecoration(
        color: styles.nBackgroundColor,
        shape: SmoothRectangleBorder(
          borderRadius: Corners.squircleLg,
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
                  notification.content.title!,
                  style: styles.nTitleTextStyle,
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                MText(
                  DateHelpers.calculateTimeAgo(notification.createdAt),
                  style: styles.nSubtitleTextStyle,
                  color: styles.nSubtitleColor,
                ),
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
              image: notification.content.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(notification.content.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: const Center(child: MPlaceholder(dimension: 30)),
          ),
          Spaces.horizontalSmall,
          const SizedBox(
            width: 16,
            height: 16,
            child: MIconButton(
              icon: Icon(MIcons.dots_vertical, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

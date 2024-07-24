import 'package:figma_squircle/figma_squircle.dart';
import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

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
        shape: SmoothRectangleBorder(
          borderRadius: $styles.radius.squircleLarge,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MBadge.small(),
          $styles.spaces.horizontalSmall,
          MAvatar(radius: 24.toScale),
          $styles.spaces.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  notification.content.title!,
                  style: styles.nTitleTextStyle,
                  maxLines: 4,
                ),
                14.vSpace,
                MText(
                  DateHelpers.calculateTimeAgo(notification.createdAt),
                  style: styles.nSubtitleTextStyle,
                  color: styles.nSubtitleColor,
                ),
              ],
            ),
          ),
          $styles.spaces.horizontalSmall,
          Container(
            height: 80.toScale,
            width: 88.toScale,
            decoration: BoxDecoration(
              borderRadius: $styles.radius.medium,
              border: Border.all(),
              image: notification.content.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(notification.content.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Center(child: MPlaceholder(dimension: 30.toScale)),
          ),
          $styles.spaces.horizontalSmall,
          SizedBox(
            width: 16.toScale,
            height: 16.toScale,
            child: MIconButton(
              icon: Icon(MIcons.dots_vertical, size: 16.toScale),
            ),
          ),
        ],
      ),
    );
  }
}

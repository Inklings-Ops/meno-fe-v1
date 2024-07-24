import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

class SubscribeNotificationCard extends StatelessWidget {
  const SubscribeNotificationCard({super.key, required this.notification});
  final Notification notification;

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
          MAvatar(
            radius: 24.toScale,
            url: notification.content.subscriberImageUrl,
          ),
          $styles.spaces.horizontalSmall,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  '${notification.content.subscriberName} just subscribed to you',
                  style: styles.nTitleTextStyle,
                  maxLines: 2,
                ),
                $styles.spaces.verticalSmall,
                MText(
                  '3 days ago',
                  style: styles.nSubtitleTextStyle,
                  color: styles.nSubtitleColor,
                ),
              ],
            ),
          ),
          $styles.spaces.horizontalSmall,
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 16.toScale,
              height: 16.toScale,
              child: MIconButton(
                icon: Icon(MIcons.dots_vertical, size: 16.toScale),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

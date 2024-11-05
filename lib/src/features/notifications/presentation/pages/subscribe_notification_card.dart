import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

class SubscribeNotificationCard extends StatelessWidget {
  const SubscribeNotificationCard({required this.notification, super.key});
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
            radius: 24,
            url: notification.content.subscriberImageUrl,
          ),
          Spaces.horizontalSmall,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  '''${notification.content.subscriberName} just subscribed to you''',
                  style: styles.nTitleTextStyle,
                  maxLines: 2,
                ),
                Spaces.verticalSmall,
                MText(
                  '3 days ago',
                  style: styles.nSubtitleTextStyle,
                  color: styles.nSubtitleColor,
                ),
              ],
            ),
          ),
          Spaces.horizontalSmall,
          const Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 16,
              height: 16,
              child: MIconButton(
                icon: Icon(MIcons.dots_vertical, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

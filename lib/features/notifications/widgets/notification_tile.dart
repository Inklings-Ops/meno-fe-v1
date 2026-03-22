import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notifications/models/_models.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends WatchingWidget {
  const NotificationCard({required this.proxy, super.key});

  final NotificationProxy proxy;

  @override
  Widget build(BuildContext context) {
    watch(proxy);

    final notification = proxy.notification;

    final card = switch (notification.type) {
      NotificationType.addedAsCoHost => _CohostNotificationTile(
        notification: notification,
      ),
      NotificationType.liveBroadcastStarted => _LiveBroadcastNotificationTile(
        notification: notification,
      ),
      NotificationType.userSubscribed => _SubscribeNotificationTile(
        notification: notification,
      ),
      null => const SizedBox.shrink(),
    };

    return Opacity(
      opacity: proxy.isRead ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: proxy.isRead ? null : proxy.markAsRead.run,
        child: card,
      ),
    );
  }
}

class _CohostNotificationTile extends StatelessWidget {
  const _CohostNotificationTile({required this.notification});

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context);
    final time = timeago.format(notification.createdAt ?? DateTime.now());

    return Container(
      padding: styles.nCardContentPadding,
      decoration: BoxDecoration(
        color: styles.backgroundColor,
        borderRadius: styles.nBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          MAvatar(radius: 24, url: notification.content?.cohostImageUrl),
          Spaces.horizontalSmall,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  '''${notification.content?.cohostFullName} added you as co-host''',
                  style: styles.nTitleTextStyle,
                  maxLines: 2,
                ),
                Spaces.verticalSmall,
                MText(
                  time,
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
              child: MIconButton(icon: Icon(MIcons.dots_vertical, size: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBroadcastNotificationTile extends StatelessWidget {
  const _LiveBroadcastNotificationTile({required this.notification});

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final styles = MCardStyles.of(context);
    final time = timeago.format(notification.createdAt ?? DateTime.now());

    return Container(
      padding: styles.nCardContentPadding,
      decoration: ShapeDecoration(
        color: styles.nBackgroundColor,
        shape: const RoundedSuperellipseBorder(
          borderRadius: .all(.circular(16)),
        ),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          const MBadge.small(),
          Spaces.horizontalSmall,
          const MAvatar(radius: 24, child: Icon(MIcons.image)),
          Spaces.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                MText(
                  notification.content!.title!,
                  color: colors.onBackground,
                  style: styles.nTitleTextStyle,
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                MText(
                  time,
                  style: styles.nSubtitleTextStyle,
                  color: styles.nSubtitleColor,
                ),
              ],
            ),
          ),
          Spaces.horizontalSmall,
          if (notification.content?.imageUrl != null) ...[
            CachedNetworkImage(
              height: 80,
              width: 88,
              imageUrl: notification.content!.imageUrl!,
              imageBuilder: (context, imageProvider) => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: Corners.md,
                  border: .all(),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const MShimmer(borderRadius: 16),
            ),
          ] else ...[
            Container(
              height: 80,
              width: 88,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: Corners.md,
                border: .all(),
              ),
              child: switch (colors.brightness) {
                .dark => Assets.images.logoLight.svg(height: 32),
                _ => Assets.images.logoDark.svg(height: 32),
              },
            ),
          ],
          Spaces.horizontalSmall,
          const SizedBox(
            width: 16,
            height: 16,
            child: MIconButton(icon: Icon(MIcons.dots_vertical, size: 16)),
          ),
        ],
      ),
    );
  }
}

class _SubscribeNotificationTile extends StatelessWidget {
  const _SubscribeNotificationTile({required this.notification});

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context);
    final time = timeago.format(notification.createdAt ?? DateTime.now());

    return Container(
      padding: styles.nCardContentPadding,
      decoration: BoxDecoration(
        color: styles.backgroundColor,
        borderRadius: styles.nBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          MAvatar(radius: 24, url: notification.content?.subscriberImageUrl),
          Spaces.horizontalSmall,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  '''${notification.content?.subscriberName} just subscribed to you''',
                  style: styles.nTitleTextStyle,
                  maxLines: 2,
                ),
                Spaces.verticalSmall,
                MText(
                  time,
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
              child: MIconButton(icon: Icon(MIcons.dots_vertical, size: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/notifications/models/_models.dart';
import 'package:meno/features/notifications/widgets/notification_options_modal.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends WatchingWidget {
  const NotificationCard({required this.proxy, super.key});

  final NotificationProxy proxy;

  @override
  Widget build(BuildContext context) {
    watch(proxy);

    final notification = proxy.notification;
    final isRead = proxy.isRead;

    void onOptionsPressed() => NotificationOptionsModal.show(context, proxy);

    return switch (notification.type) {
      NotificationType.addedAsCoHost => _CohostNotificationTile(
        notification: notification,
        isRead: isRead,
        onOptionsPressed: onOptionsPressed,
      ),
      NotificationType.liveBroadcastStarted => _LiveBroadcastNotificationTile(
        notification: notification,
        isRead: isRead,
        onOptionsPressed: onOptionsPressed,
        onPressed: () {
          final broadcastId1 = notification.content?.id;
          final broadcastId2 = notification.content?.broadcastId;
          final effectiveBroadcastId = broadcastId1 ?? broadcastId2;
          if (effectiveBroadcastId == null) return;
          context.push(R.preStream(effectiveBroadcastId));
          proxy.markAsRead.run();
        },
      ),
      NotificationType.userSubscribed => _SubscribeNotificationTile(
        notification: notification,
        isRead: isRead,
        onOptionsPressed: onOptionsPressed,
      ),
      null => const SizedBox.shrink(),
    };
  }
}

class _CohostNotificationTile extends StatelessWidget {
  const _CohostNotificationTile({
    required this.notification,
    required this.onOptionsPressed,
    required this.isRead,
  });

  final Notification notification;
  final void Function() onOptionsPressed;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context);
    final time = timeago.format(notification.createdAt ?? DateTime.now());

    return Container(
      padding: styles.nCardContentPadding,
      decoration: !isRead
          ? BoxDecoration(
              color: styles.backgroundColor,
              borderRadius: styles.nBorderRadius,
            )
          : null,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Spaces.horizontalSmall,
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
              _MoreOptionsButton(onOptionsPressed: onOptionsPressed),
            ],
          ),
          if (!isRead) const Align(alignment: .topLeft, child: MBadge.small()),
        ],
      ),
    );
  }
}

class _LiveBroadcastNotificationTile extends StatelessWidget {
  const _LiveBroadcastNotificationTile({
    required this.notification,
    required this.onPressed,
    required this.onOptionsPressed,
    required this.isRead,
  });

  final Notification notification;
  final void Function() onPressed;
  final void Function() onOptionsPressed;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final styles = MCardStyles.of(context);
    final time = timeago.format(notification.createdAt ?? DateTime.now());

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: styles.nCardContentPadding,
        decoration: !isRead
            ? ShapeDecoration(
                color: styles.nBackgroundColor,
                shape: const RoundedSuperellipseBorder(
                  borderRadius: .all(.circular(16)),
                ),
              )
            : null,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: .start,
              children: [
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
                    placeholder: (context, url) =>
                        const MShimmer(borderRadius: 16),
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
                _MoreOptionsButton(onOptionsPressed: onOptionsPressed),
              ],
            ),
            if (!isRead)
              const Align(alignment: .topLeft, child: MBadge.small()),
          ],
        ),
      ),
    );
  }
}

class _SubscribeNotificationTile extends StatelessWidget {
  const _SubscribeNotificationTile({
    required this.notification,
    required this.isRead,
    required this.onOptionsPressed,
  });

  final Notification notification;
  final bool isRead;
  final void Function() onOptionsPressed;

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context);
    final time = timeago.format(notification.createdAt ?? DateTime.now());

    return Container(
      padding: styles.nCardContentPadding,
      decoration: !isRead
          ? BoxDecoration(
              color: styles.backgroundColor,
              borderRadius: styles.nBorderRadius,
            )
          : null,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Spaces.horizontalSmall,
              MAvatar(
                radius: 24,
                url: notification.content?.subscriberImageUrl,
              ),
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
              _MoreOptionsButton(onOptionsPressed: onOptionsPressed),
            ],
          ),
          if (!isRead) const Align(alignment: .topLeft, child: MBadge.small()),
        ],
      ),
    );
  }
}

class _MoreOptionsButton extends StatelessWidget {
  const _MoreOptionsButton({required this.onOptionsPressed});

  final void Function() onOptionsPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: 16,
        height: 16,
        child: MIconButton(
          icon: const Icon(MIcons.dots_vertical, size: 16),
          onPressed: onOptionsPressed,
        ),
      ),
    );
  }
}

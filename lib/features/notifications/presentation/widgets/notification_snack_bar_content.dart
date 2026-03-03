import 'package:flutter/material.dart' hide Notification;
import 'package:meno/features/notifications/domain/entities/notification.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationSnackBarContent extends StatelessWidget {
  const NotificationSnackBarContent({required this.notification, super.key});

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final content = notification.content!;

    final time = timeago.format(notification.createdAt ?? DateTime.now());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Insets.sm,
      children: [
        const MAvatar(radius: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MText(
                '''Broadcast is Live: ${content.title}''',
                style: textTheme.captionRegular,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              MText(time, style: textTheme.microMedium, color: colors.inActive),
            ],
          ),
        ),
        const MAvatar(radius: 40),
      ],
    );
  }
}

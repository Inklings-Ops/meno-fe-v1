import 'package:get_time_ago/get_time_ago.dart';
import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

class NotificationSnackBarContent extends StatelessWidget {
  const NotificationSnackBarContent({required this.notification, super.key});
  final Notification notification;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    final content = notification.content!;
    final time = GetTimeAgo.parse(notification.createdAt ?? DateTime.now());

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
              MText(
                time,
                style: textTheme.microMedium,
                color: colors.inActive,
              ),
            ],
          ),
        ),
        const MAvatar(radius: 40),
      ],
    );
  }
}

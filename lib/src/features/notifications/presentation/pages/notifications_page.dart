import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return RefreshIndicator(
    //   onRefresh: () => ref.read(notificationsNotifierProvider.future),
    //   child: notifications.when(
    //     data: (_) =>
    //         _Content(notifications: ref.watch(sortNotificationsProvider)),
    //     error: (_, __) => const Text('Oops, something unexpected happened'),
    //     loading: () => const Center(child: CircularProgressIndicator()),
    //   ),
    // );
    return const MScaffold(
      appBar: _AppBar(),
      body: Text('Oops'),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.notifications});
  final Map<NotificationCategory, List<Notification?>> notifications;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final today = notifications[NotificationCategory.today];
    final thisWeek = notifications[NotificationCategory.thisWeek];
    final older = notifications[NotificationCategory.older];

    return MScaffold(
      appBar: const _AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              if (today?.isNotEmpty ?? false) ...[
                Spaces.verticalXLarge,
                MText('Today', style: textTheme.captionMedium),
                Spaces.verticalLarge,
                NotificationList(notifications: today!),
              ],
              if (thisWeek?.isNotEmpty ?? false) ...[
                Spaces.verticalXXLarge,
                MText('This Week', style: textTheme.captionMedium),
                Spaces.verticalLarge,
                NotificationList(notifications: thisWeek!),
              ],
              if (older?.isNotEmpty ?? false) ...[
                Spaces.verticalXXLarge,
                MText('Older', style: textTheme.captionMedium),
                Spaces.verticalLarge,
                NotificationList(notifications: older!),
              ],
            ]),
          ),
        ],
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({required this.notifications, super.key});
  final List<Notification?> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) => switch (notifications[i]?.type) {
        NotificationType.liveBroadcastStarted =>
          LiveNotificationCard(notification: notifications[i]!),
        NotificationType.userSubscribed =>
          SubscribeNotificationCard(notification: notifications[i]!),
        _ => const SizedBox(),
      },
      separatorBuilder: (context, i) => Spaces.verticalLarge,
      itemCount: notifications.length,
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: MBackButton.withText(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: MHeader(title: 'Notifications'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86);
}

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

class NotificationsPage extends HookConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsNotifierProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(notificationsNotifierProvider.future),
      child: notifications.when(
        data: (_) =>
            _Content(notifications: ref.watch(sortNotificationsProvider)),
        error: (_, __) => const Text('Oops, something unexpected happened'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.notifications});
  final Map<NotificationCategory, List<Notification?>> notifications;

  @override
  Widget build(BuildContext context) {
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
                24.vSpace,
                MText('Today', style: $styles.text.captionMedium),
                $styles.spaces.verticalLarge,
                NotificationList(notifications: today!),
              ],
              if (thisWeek?.isNotEmpty ?? false) ...[
                $styles.spaces.verticalXXLarge,
                MText('This Week', style: $styles.text.captionMedium),
                $styles.spaces.verticalLarge,
                NotificationList(notifications: thisWeek!),
              ],
              if (older?.isNotEmpty ?? false) ...[
                $styles.spaces.verticalXXLarge,
                MText('Older', style: $styles.text.captionMedium),
                $styles.spaces.verticalLarge,
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
  const NotificationList({super.key, required this.notifications});
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
      separatorBuilder: (context, i) => $styles.spaces.verticalLarge,
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
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ).radius,
            child: const MBackButton.withText(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8).radius,
            child: const MHeader(title: 'Notifications'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(86.toScale);
}

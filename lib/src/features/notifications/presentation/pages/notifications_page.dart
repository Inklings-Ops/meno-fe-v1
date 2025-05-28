import 'package:meno_fe_v1/meno.dart' hide Notification;
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotificationsBloc>();

    Future<void> onRefresh() async {
      final notifications = bloc.stream.first;
      bloc.add(const GetNotifications());
      await notifications;
    }

    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: MScaffold(
        appBar: const _AppBar(),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) => state.when(
            empty: () => const Center(child: Text('Nothing to see here')),
            loading: () => _Content(
              notifications: fakeNotifications,
              loading: true,
            ),
            loaded: (notifications) => _Content(notifications: notifications),
            failure: (exception) => Text(
              exception.maybeWhen(
                message: (message) => message,
                orElse: () => "Something's not right",
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.notifications, this.loading = false});
  final Map<NotificationCategory, List<Notification?>> notifications;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final today = notifications[NotificationCategory.today];
    final thisWeek = notifications[NotificationCategory.thisWeek];
    final older = notifications[NotificationCategory.older];

    return Skeletonizer(
      enabled: loading,
      child: CustomScrollView(
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

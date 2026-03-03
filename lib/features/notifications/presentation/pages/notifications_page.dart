import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/notifications/notifications.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsPage extends WatchingWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (di) {
        di.registerLazySingleton(() {
          return NotificationHttpDataSource(di<ApiClient>());
        });

        di.registerLazySingleton<INotificationRepository>(() {
          return NotificationRepositoryImpl(di<NotificationHttpDataSource>());
        });

        di.registerLazySingletonAsync<NotificationsManager>(() async {
          final manager = NotificationsManager(di<INotificationRepository>());
          await manager.fetch.runAsync();
          return manager;
        });
      },
    );

    final page = watchValue((NotificationsManager m) => m.notifications);
    final isLoading = watchValue((NotificationsManager m) => m.fetch.isRunning);
    final errors = watchValue((NotificationsManager m) => m.fetch.errors);

    if (isLoading) {
      return MScaffold(
        appBar: const _AppBar(),
        body: _Content(notifications: fakeNotifications, loading: true),
      );
    }

    if (errors?.error != null && !isLoading) {
      return MScaffold(
        appBar: const _AppBar(),
        body: MenoErrorWidget(error: errors?.error),
      );
    }

    if (!isLoading && page.isEmpty) {
      return const MScaffold(appBar: _AppBar(), body: MenoEmptyWidget());
    }

    return MScaffold(
      appBar: const _AppBar(),
      body: _Content(notifications: fakeNotifications),
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
        NotificationType.liveBroadcastStarted => LiveNotificationCard(
          notification: notifications[i]!,
        ),
        NotificationType.userSubscribed => SubscribeNotificationCard(
          notification: notifications[i]!,
        ),
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
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

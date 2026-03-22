import 'package:meno/features/notifications/models/proxies/notification_proxy.dart';

sealed class NotificationListItem {
  const NotificationListItem();
}

final class NotificationSectionHeader extends NotificationListItem {
  const NotificationSectionHeader(this.label);

  final String label;
}

final class NotificationListEntry extends NotificationListItem {
  const NotificationListEntry(this.proxy);

  final NotificationProxy proxy;
}

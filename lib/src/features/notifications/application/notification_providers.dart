import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../dependency_injector/injector.dart';
import '../domain/i_notification_facade.dart';

part 'notification_providers.g.dart';

@riverpod
INotificationFacade notificationFacade(NotificationFacadeRef ref) {
  return di<INotificationFacade>();
}

import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
import 'package:meno_fe_v1/src/features/notifications/domain/i_notification_facade.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_providers.g.dart';

@riverpod
INotificationFacade notificationFacade(NotificationFacadeRef ref) {
  return di<INotificationFacade>();
}

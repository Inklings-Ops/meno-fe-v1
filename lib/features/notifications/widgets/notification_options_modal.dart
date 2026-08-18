import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/features/notifications/models/_models.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotificationOptionsModal extends WatchingWidget {
  const NotificationOptionsModal._(this.proxy) : super(key: null);
  final NotificationProxy proxy;

  static Future<dynamic> show(BuildContext context, NotificationProxy proxy) {
    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) => NotificationOptionsModal._(proxy),
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final user = proxy.notification.content?.broadcastCreator ?? 'this user';
    return MModal(
      builder: (context) => Column(
        mainAxisSize: .min,
        spacing: 16,
        children: [
          MModalListTile(
            leading: const Icon(MIcons.bell_off_03),
            title: 'Turn off from $user',
            onTap: () {},
          ),
          MModalListTile(
            leading: Icon(MIcons.trash, color: colors.error),
            title: 'Delete',
            onTap: () {
              proxy.delete.run();
              context.pop();
            },
            titleColor: colors.error,
          ),
        ],
      ),
    );
  }
}

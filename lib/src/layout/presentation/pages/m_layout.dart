import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/services/notification_service.dart';

import '../../../router/router.dart';
import '../../../services/socket/socket_service.dart';
import '../../../shared/constants/m_bottom_navigation_bar_items.dart';

class MLayout extends StatefulHookConsumerWidget {
  final StatefulNavigationShell shell;

  const MLayout({
    Key? key,
    required this.shell,
  }) : super(key: key ?? const ValueKey<String>('MLayout'));

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MLayoutState();
}

class _MLayoutState extends ConsumerState<MLayout> {
  final _fcm = FirebaseMessaging.instance;

  String? initialMessage;
  bool _resolved = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(socketServiceProvider);

    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: MBottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: widget.shell.currentIndex,
        onTap: (index) => widget.shell.goBranch(
          index,
          initialLocation: index == widget.shell.currentIndex,
        ),
        customItem: MBottomBarNavigationItem(
          selected: false,
          onTap: () => context.push(Routes.createBroadcast),
          customItem: const Microphone(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _fcm.getInitialMessage().then((value) => setState(() {
          _resolved = true;
          initialMessage = value?.data.toString();
        }));

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      context.go(Routes.notifications);
    });
    handleFCMToken();
  }
}

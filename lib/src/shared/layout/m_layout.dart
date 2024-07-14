import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:meno_fe_v1/src/services/notification_service.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../../router/router.dart';

class MLayout extends StatefulWidget {
  final StatefulNavigationShell shell;

  const MLayout({
    Key? key,
    required this.shell,
  }) : super(key: key ?? const ValueKey<String>('MLayout'));

  @override
  State<MLayout> createState() => _MLayoutState();
}

class _MLayoutState extends State<MLayout> {
  final _fcm = FirebaseMessaging.instance;

  String? initialMessage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (user, token) {
            context.read<MyProfileBloc>().add(const MyProfileEvent.fetch());
          },
        );
      },
      child: Scaffold(
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _fcm.getInitialMessage().then((value) => setState(() {
          initialMessage = value?.data.toString();
        }));

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      context.push(Routes.notifications);
    });
    handleFCMToken();
  }
}

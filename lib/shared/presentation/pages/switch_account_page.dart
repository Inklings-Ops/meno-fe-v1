import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/auth/application/application.dart';
import 'package:meno/shared/domain/value_objects/id.dart';
import 'package:meno_design_system/meno_design_system.dart';

class SwitchAccountPage extends WatchingWidget {
  const SwitchAccountPage({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final id = Id.fromString(userId);

    callOnce((_) => di<AuthManager>().switchAccount.run(id));

    registerHandler(
      select: (AuthManager m) => m.switchAccount,
      handler: (context, newValue, cancel) => context.go(R.home),
    );

    return const Scaffold(body: Center(child: MLoadingIndicator.box()));
  }
}

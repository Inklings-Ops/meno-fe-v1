import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_di/user_scope_locator.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/pages/loading_page.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';

class SwitchAccountPage extends WatchingWidget {
  const SwitchAccountPage({required this.userIdStr, super.key});

  final String userIdStr;

  @override
  Widget build(BuildContext context) {
    callOnce((_) {
      popUserSessionScope();
      di<AuthManager>().switchAccount.run(.fromString(userIdStr));
    });

    registerHandler(
      select: (AuthManager m) => m.switchAccount,
      handler: (context, result, cancel) => context.go(R.home),
    );

    registerHandler(
      select: (AuthManager m) => m.switchAccount.errors,
      handler: (context, error, cancel) => context.pop(),
    );

    return const LoadingPage();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/applications/auth_manager.dart';
import 'package:meno/shared/shared.dart';

class SwitchAccountPage extends WatchingWidget {
  const SwitchAccountPage({required this.userIdStr, super.key});

  final String userIdStr;

  @override
  Widget build(BuildContext context) {
    callOnce((_) {
      final userId = Id.fromString(userIdStr);
      di<UserScopeInjector>().clearUserScope();
      di<AuthManager>().switchAccount.run(userId);
    });

    registerHandler(
      select: (AuthManager m) => m.switchAccount,
      handler: (context, newValue, cancel) => context.go(R.home),
    );

    return const LoadingPage();
  }
}

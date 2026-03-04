import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/widgets/_loading_page.dart';
import 'package:meno/features/auth/manager/auth_manager.dart';

class SwitchAccountPage extends WatchingWidget {
  const SwitchAccountPage({required this.userIdStr, super.key});

  final String userIdStr;

  @override
  Widget build(BuildContext context) {
    callOnce((_) {
      final userId = Id.fromString(userIdStr);
      // di<UserScopeInjector>().clearUserScope();
      di<AuthManager>().switchAccount.run(userId);
    });

    registerHandler(
      select: (AuthManager m) => m.switchAccount,
      handler: (context, newValue, cancel) => context.go(R.home),
    );

    return const LoadingPage();
  }
}

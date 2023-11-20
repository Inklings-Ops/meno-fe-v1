import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../application/application.dart';
import 'login_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  final bool implyLeading;
  final bool isPasswordOnly;

  const LoginPage({
    super.key,
    this.implyLeading = false,
    this.isPasswordOnly = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) => MScaffold(
        appBar: MAppBar.primary(
          title: "Log in",
          implyLeading: widget.implyLeading,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24).r,
          child: LoginForm(isPasswordOnly: widget.isPasswordOnly),
        ),
      );

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.isPasswordOnly) {
    //     final IEmail email = ref.read(userProvider).email;
    //     ref.read(loginFormNotifierProvider.notifier).emailChanged(email.get()!);
    //   }
    // });

    ref.listenManual(authProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => context.showLoginError(failure),
          (_) => null,
        ),
      );
    });
  }
}

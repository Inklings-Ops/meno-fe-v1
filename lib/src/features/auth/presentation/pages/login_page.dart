import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/application.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/recently_live/recently_live_cubit.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  final bool implyLeading;
  final bool isPasswordOnly;

  const LoginPage({
    super.key,
    this.implyLeading = false,
    this.isPasswordOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (p, c) => p.option != c.option,
      listener: (context, state) {
        state.option.fold(
          () => null,
          (either) => either.fold(
            (failure) => context.showLoginError(failure),
            (success) {
              context.read<MyProfileBloc>().add(const MyProfileEvent.fetch());
              context.read<RecentlyLiveCubit>().fetch();
            },
          ),
        );
      },
      child: MScaffold(
        appBar: MAppBar.primary(title: 'Log in', implyLeading: implyLeading),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginForm(isPasswordOnly: isPasswordOnly),
              24.verticalSpace,
              const GoogleDivider(title: 'Or'),
              24.verticalSpace,
              const MGoogleButton(title: 'Login with Google'),
              149.verticalSpace,
              AuthRedirectionText(
                title: 'Don\'t have an account?',
                buttonText: 'Create an account',
                onPressed: () => context.replace(Routes.registerWithLeading),
              )
            ],
          ),
        ),
      ),
    );
  }
}

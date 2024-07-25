import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

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
              context.read<SessionCubit>().init();
              context.read<AccountBloc>().init();
              context.read<RecentlyLiveCubit>().fetch();
              context.read<MyProfileBloc>().init(success.user.id.getOr());
            },
          ),
        );
      },
      child: MScaffold(
        appBar: MAppBar.primary(title: 'Log in', implyLeading: implyLeading),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24.toScale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginForm(isPasswordOnly: isPasswordOnly),
              24.vSpace,
              const GoogleDivider(title: 'Or'),
              24.vSpace,
              const MGoogleButton(title: 'Login with Google'),
              144.vSpace,
              AuthRedirectionText(
                title: 'Don\'t have an account?',
                buttonText: 'Create an account',
                onPressed: () => implyLeading
                    ? router.replace(Routes.register, extra: true)
                    : router.push(Routes.register, extra: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}

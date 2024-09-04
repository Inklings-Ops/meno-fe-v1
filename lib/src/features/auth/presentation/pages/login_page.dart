import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
    this.implyLeading = false,
    this.isPasswordOnly = false,
  });
  final bool implyLeading;
  final bool isPasswordOnly;

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
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginForm(isPasswordOnly: isPasswordOnly),
              Spaces.verticalXLarge,
              const GoogleDivider(title: 'Or'),
              Spaces.verticalXLarge,
              const MGoogleButton(title: 'Login with Google'),
              const SizedBox(height: 144),
              AuthRedirectionText(
                title: "Don't have an account?",
                buttonText: 'Create an account',
                onPressed: () => implyLeading
                    ? const RegisterRoute().replace(context)
                    : const RegisterRoute().push<void>(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

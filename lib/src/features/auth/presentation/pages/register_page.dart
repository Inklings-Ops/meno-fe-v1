import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/settings/application/application.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, this.implyLeading = true});
  final bool implyLeading;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(facade: di<IAuthFacade>()),
      child: RegisterView(implyLeading: implyLeading),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key, this.implyLeading = true});
  final bool implyLeading;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        switch (state.status) {
          case FormStatus.failure:
            context.showErrorSnackBar(state.exception!.message);
          case FormStatus.success:
          case FormStatus.canceled:
          case FormStatus.initial:
          case FormStatus.loading:
            break;
        }
      },
      child: MScaffold(
        appBar: MAppBar.primary(
          title: 'New Account',
          backText: 'Go back',
          implyLeading: implyLeading,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const RegisterForm(),
              Spaces.verticalXXLarge,
              const GoogleDivider(title: 'Or'),
              Spaces.verticalXLarge,
              const MGoogleButton(title: 'Create with Google'),
              const SizedBox(height: 44),
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) => AuthRedirectionText(
                  title: 'Already have an account?',
                  buttonText: 'Log in',
                  onPressed: () {
                    if (state == OnboardingState.completed) {
                      router.replace<void>(Routes.login);
                    } else {
                      router.replace<void>(Routes.loginWithLeading);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/settings/application/application.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, this.implyLeading = true});
  final bool implyLeading;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        state.option.fold(
          () => null,
          (either) => either.fold(
            (failure) => context.showRegistrationError(failure),
            (success) => null,
          ),
        );
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

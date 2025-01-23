import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

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
    return BlocProvider(
      create: (context) => LoginCubit(
        facade: di<IAuthFacade>(),
        settingsFacade: di<ISettingsFacade>(),
      ),
      child: LoginView(
        implyLeading: implyLeading,
        isPasswordOnly: isPasswordOnly,
      ),
    );
  }
}

class LoginView extends HookWidget {
  const LoginView({
    super.key,
    this.implyLeading = false,
    this.isPasswordOnly = false,
  });
  final bool implyLeading;
  final bool isPasswordOnly;

  @override
  Widget build(BuildContext context) {
    final email = context.select(
      (SessionCubit bloc) => bloc.state.whenOrNull(
        partiallyAuthenticated: (user) => user.email.getOr(),
      ),
    );

    useEffect(
      () {
        if (isPasswordOnly) context.read<LoginCubit>().emailChanged(email!);
        return null;
      },
      const [],
    );

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (p, c) => p.option != c.option,
      listener: (context, state) {
        state.option.fold(
          () => null,
          (either) => either.fold(
            (failure) => context.showLoginError(failure),
            (success) {
              context.read<SessionCubit>().init();
              context.read<RecentlyLiveCubit>().fetch();
              context.read<AccountBloc>().init();
              context.read<MyProfileCubit>().fetch();
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
                onPressed: () {
                  if (context.read<LoginCubit>().isOnboarded) {
                    router.push<void>(Routes.register);
                  } else {
                    router.replace<void>(Routes.register);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

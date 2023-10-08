import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/core/extensions/extensions.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';
import 'package:meno_fe_v1/features/auth/application/login/login_notifier.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/auth_redirection_text.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/google_divider.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/user_account_details.dart';
import 'package:meno_fe_v1/features/onboarding/application/onboarding_provider.dart';
import 'package:meno_fe_v1/router/m_router.dart';

part 'login_page.widgets.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@RoutePage()
class LoginPage extends StatefulHookConsumerWidget {
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
  Widget build(BuildContext context) {
    final FocusScopeNode focusScope = useFocusScopeNode();
    final FocusNode emailFocusNode = useFocusNode();
    final FocusNode passwordFocusNode = useFocusNode();

    final LoginState state = ref.watch(loginProvider);

    ref.listen<LoginState>(loginProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => context.showLoginError(failure),
          (_) async {
            final router = context.router;
            router.replaceAll([const MLayoutRoute()]);
            context.clearSnackBars();
            await ref.read(authProvider.notifier).checkAuthenticated();
            if (router.canNavigateBack) {
              ref.read(onboardingProvider).onboardingCompleted();
            }
          },
        ),
      );
    });

    final onLoginPressed = useCallback(() {
      focusScope.unfocus();
      if (_formKey.currentState?.validate() == true) {
        ref.read(loginProvider.notifier).loginPressed();
      }
    }, []);

    return Scaffold(
      appBar: MAppBar.primary(
        title: "Log in",
        implyLeading: widget.implyLeading,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 56),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.isPasswordOnly) ...[
                UserAccountDetails(
                  user: ref.watch(userProvider),
                  action: context.showSwitchAccountSheet,
                ),
                MSize.verticalSpaceXXLarge,
              ] else ...[
                _Email(focusNode: emailFocusNode),
                24.verticalSpace,
              ],
              _Password(focusNode: passwordFocusNode),
              MSize.verticalSpaceMicro,
              const Align(
                alignment: Alignment.centerRight,
                child: _ForgotPasswordButton(),
              ),
              MSize.verticalSpaceXXLarge,
              MPrimaryButton(
                label: "Log In",
                loading: state.loading,
                onPressed: onLoginPressed,
              ),
              24.verticalSpace,
              const GoogleDivider(title: "Login with Google"),
              24.verticalSpace,
              MGoogleButton(onPressed: () {}),
              149.verticalSpace,
              AuthRedirectionText(
                title: "Don’t have an account?",
                buttonText: "Create an account",
                onPressed: () => context.replaceRoute(const RegisterRoute()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isPasswordOnly) {
        final IEmail email = ref.read(authProvider).user.email;
        ref.read(loginProvider.notifier).emailChanged(email.get()!);
      }
    });
  }
}

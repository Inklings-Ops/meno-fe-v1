import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/core/extensions/m_extensions.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_providers.dart';
import 'package:meno_fe_v1/features/auth/application/return_login/return_login_notifier.dart';
import 'package:meno_fe_v1/features/auth/domain/domain.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/auth_redirection_text.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/forgot_password_button.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/google_divider.dart';
import 'package:meno_fe_v1/router/m_router.dart';
import 'package:meno_fe_v1/shared/modals/m_switch_account_modal.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@RoutePage()
class ReturnLoginPage extends HookConsumerWidget {
  const ReturnLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User user = ref.watch(userProvider);

    final FocusScopeNode focusScope = useFocusScopeNode();
    final FocusNode passwordFocusNode = useFocusNode();

    final ReturnLoginState state = ref.watch(returnLoginProvider);

    final onLoginPressed = useCallback(() {
      focusScope.unfocus();
      if (_formKey.currentState?.validate() == true) {
        ref.read(returnLoginProvider.notifier).loginPressed();
      }
    }, []);

    ref.listen<ReturnLoginState>(returnLoginProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => context.showErrorSnackBar(
            failure.maybeMap(
              orElse: () => '',
              invalidEmailOrPassword: (_) => "Invalid password",
              networkError: (_) => "No internet connection",
              serverError: (_) => 'Server error. Try again',
              timeOutError: (_) => "The server timed out. Try again.",
              unknownError: (_) => 'Unknown error. Try again',
            ),
          ),
          (_) {
            context.clearSnackBars();
            // AuthNotifier().checkAuthenticated();
            context.router.replaceAll([const MLayoutRoute()]);
          },
        ),
      );
    });

    return Scaffold(
      appBar: MAppBar.primary(title: "Log in", implyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 56),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 74,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const MText(
                            "Welcome back,",
                            style: MTextStyle.subheadingMedium,
                          ),
                          MText(
                            user.fullName.get()!,
                            style: MTextStyle.heading2Medium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          foregroundImage: user.imageUrl != null
                              ? NetworkImage(user.imageUrl!)
                              : null,
                          child: Assets.images.logoDark.svg(height: 24),
                        ),
                        MSize.verticalSpaceSmall,
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const MSwitchAccountModal(),
                            );
                          },
                          child: MText(
                            "Switch account",
                            style: MTextStyle.captionMedium,
                            color: MColorScheme.of(context)?.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MSize.verticalSpaceXXLarge,
              _Password(focusNode: passwordFocusNode),
              MSize.verticalSpaceMicro,
              const Align(
                alignment: Alignment.centerRight,
                child: ForgotPasswordButton(),
              ),
              MSize.verticalSpaceXXLarge,
              MPrimaryButton(
                label: "Log In",
                onPressed: onLoginPressed,
                loading: state.loading,
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
}

class _Password extends ConsumerWidget {
  final FocusNode focusNode;
  const _Password({Key? key, required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => MTextFormField(
        label: "Be Secure",
        hint: "Enter your password",
        prefixIcon: MIcons.key,
        isPassword: true,
        focusNode: focusNode,
        enabled: !ref.watch(returnLoginProvider).loading,
        onChanged: ref.watch(returnLoginProvider.notifier).passwordChanged,
        validator: ref.watch(returnLoginProvider.notifier).validatePassword,
      );
}

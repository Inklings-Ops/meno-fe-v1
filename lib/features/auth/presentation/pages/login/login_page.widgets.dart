part of 'login_page.dart';

class _Email extends ConsumerWidget {
  final FocusNode focusNode;
  const _Email({Key? key, required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => MTextFormField(
        label: "Email Address",
        hint: "example@gmail.com",
        prefixIcon: MIcons.mail,
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        enabled: !ref.watch(loginProvider).loading,
        onChanged: ref.watch(loginProvider.notifier).emailChanged,
        validator: ref.watch(loginProvider.notifier).validateEmail,
      );
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.navigateTo(const ResetPasswordRoute()),
      child: const MText(
        "Forgot Password?",
        style: MTextStyle.captionMedium,
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
        enabled: !ref.watch(loginProvider).loading,
        onChanged: ref.watch(loginProvider.notifier).passwordChanged,
        validator: ref.watch(loginProvider.notifier).validatePassword,
      );
}

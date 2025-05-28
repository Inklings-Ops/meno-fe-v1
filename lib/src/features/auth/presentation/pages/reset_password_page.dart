import 'package:meno_fe_v1/meno.dart';

class ResetPasswordPage extends HookWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return MScaffold(
      appBar: MAppBar.primary(title: 'Reset Password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spaces.verticalXLarge,
              MText(
                '''
Please enter the email associated with your account and we will send an email with instructions to reset your password.''',
                maxLines: 3,
                style: textTheme.bodyRegular,
              ),
              Spaces.verticalXXLarge,
              const MTextFormField(
                label: 'Email Address',
                hint: 'example@gmail.com',
                prefixIcon: MIcons.mail,
              ),
              Spaces.verticalXXLarge,
              MPrimaryButton(
                label: 'Send Instructions',
                onPressed: () => router.push(Routes.resetPwdOtp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

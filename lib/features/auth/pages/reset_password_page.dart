import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ResetPasswordPage extends WatchingWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = createOnce(GlobalKey<FormState>.new);
    final textTheme = MTextTheme.of(context);
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
                onPressed: () => context.push(R.resetPwdOtp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

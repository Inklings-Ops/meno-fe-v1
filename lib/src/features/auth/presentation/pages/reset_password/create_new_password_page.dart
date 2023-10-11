import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../../application/application.dart';
import '../../widgets/widgets.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@RoutePage()
class CreateNewPasswordPage extends ConsumerWidget {
  const CreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: MAppBar.primary(title: ("Create New Password")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              24.verticalSpace,
              UserAccountDetails(user: ref.watch(userProvider)),
              MSize.verticalSpaceSmall,
              const MText(
                "Set up new password to continue your experience",
                maxLines: 2,
                style: MTextStyle.captionMedium,
              ),
              MSize.verticalSpaceXXLarge,
              const MTextFormField(
                label: "Password",
                isPassword: true,
                prefixIcon: MIcons.key,
                hint: "Enter your password",
              ),
              24.verticalSpace,
              const MTextFormField(
                label: "Confirm Password",
                isPassword: true,
                prefixIcon: MIcons.key,
                hint: "Enter your password",
              ),
              MSize.verticalSpaceXXLarge,
              MPrimaryButton(
                label: "Reset Password",
                onPressed: () {
                  context.navigateTo(const ResetPasswordSuccessRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

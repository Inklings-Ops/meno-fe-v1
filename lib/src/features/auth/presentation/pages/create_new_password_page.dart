import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../router/router.dart';
import '../widgets/widgets.dart';

class CreateNewPasswordPage extends StatelessWidget {
  const CreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.primary(title: ('Create New Password')),
      body: Form(
        child: Builder(
          builder: (formContext) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                24.verticalSpace,
                const UserAccountDetails(),
                MCore.small.verticalSpace,
                const MText(
                  'Set up new password to continue your experience',
                  maxLines: 2,
                  style: MTextStyle.captionMedium,
                ),
                MCore.xxLarge.verticalSpace,
                const MTextFormField(
                  label: 'Password',
                  isPassword: true,
                  prefixIcon: MIcons.key,
                  hint: 'Enter your password',
                ),
                24.verticalSpace,
                const MTextFormField(
                  label: 'Confirm Password',
                  isPassword: true,
                  prefixIcon: MIcons.key,
                  hint: 'Enter your password',
                ),
                MCore.xxLarge.verticalSpace,
                MPrimaryButton(
                  label: 'Reset Password',
                  onPressed: () => context.push(Routes.resetPwdSuccess),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

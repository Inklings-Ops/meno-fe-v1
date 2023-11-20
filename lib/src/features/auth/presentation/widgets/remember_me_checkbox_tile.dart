import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../application/register_form/register_form_notifier.dart';

class RememberMeCheckboxTile extends ConsumerWidget {
  const RememberMeCheckboxTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rememberMe = ref.watch(registerFormNotifierProvider.select(
      (value) => value.rememberMe,
    ));

    final notifier = ref.read(registerFormNotifierProvider.notifier);

    return Row(
      children: [
        SizedBox(
          height: 20.r,
          width: 20.r,
          child: Checkbox(
            value: rememberMe,
            onChanged: notifier.onRememberMeChanged,
          ),
        ),
        10.horizontalSpace,
        const MText("Remember me", style: MTextStyle.captionMedium),
      ],
    );
  }
}

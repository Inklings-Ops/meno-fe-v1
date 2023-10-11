import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../application/register_form/register_form_notifier.dart';

class RememberMeCheckboxTile extends ConsumerWidget {
  const RememberMeCheckboxTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(
            value: ref.watch(registerFormProvider).rememberMe,
            onChanged:
                ref.watch(registerFormProvider.notifier).onRememberMeChanged,
          ),
        ),
        10.horizontalSpace,
        const MText("Remember me", style: MTextStyle.captionMedium),
      ],
    );
  }
}

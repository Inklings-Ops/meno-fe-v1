import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast_form/broadcast_form_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class BroadcastDescriptionField extends StatelessWidget {
  const BroadcastDescriptionField(this.controller, {super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      buildWhen: (p, c) =>
          p.description != c.description || p.loading != c.loading,
      builder: (context, state) => MTextArea(
        label: 'About broadcast',
        hint: 'Enter a brief description',
        maxLines: 5,
        maxLength: 244,
        keyboardType: TextInputType.text,
        controller: controller,
        enabled: !state.loading,
        onChanged: context.read<BroadcastFormCubit>().descriptionChanged,
        validator: (_) => state.description != null
            ? context.validator(state.description!.value)
            : null,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast_form/broadcast_form_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class BroadcastTitleField extends StatelessWidget {
  const BroadcastTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      buildWhen: (p, c) => p.title != c.title || p.loading != c.loading,
      builder: (context, state) => MTextFormField(
        label: 'Broadcast title',
        hint: "Jim Halpert's live audio",
        required: true,
        enabled: !state.loading,
        textInputAction: TextInputAction.next,
        onChanged: context.read<BroadcastFormCubit>().titleChanged,
        validator: (_) => context.validator(state.title.value),
      ),
    );
  }
}

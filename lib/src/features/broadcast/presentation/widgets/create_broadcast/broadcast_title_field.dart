import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

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

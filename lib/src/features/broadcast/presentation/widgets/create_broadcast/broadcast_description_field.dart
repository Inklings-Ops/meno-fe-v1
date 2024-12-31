import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastDescriptionField extends StatelessWidget {
  const BroadcastDescriptionField(this.controller, {super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<LiveBloc, bool>(
      (bloc) => bloc.state is LiveLoading,
    );

    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      buildWhen: (p, c) => p.description != c.description || isLoading,
      builder: (context, state) => MTextArea(
        label: 'About broadcast',
        hint: 'Enter a brief description',
        maxLines: 5,
        maxLength: 244,
        controller: controller,
        enabled: !isLoading,
        onChanged: context.read<BroadcastFormCubit>().descriptionChanged,
        validator: (_) => state.description != null
            ? context.validator(state.description!.value)
            : null,
      ),
    );
  }
}

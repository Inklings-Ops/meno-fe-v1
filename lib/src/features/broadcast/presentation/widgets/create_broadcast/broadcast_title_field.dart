import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastTitleField extends StatelessWidget {
  const BroadcastTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<BroadcastBloc, bool>(
      (bloc) => bloc.state.status.isLoading,
    );

    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      buildWhen: (p, c) => p.title != c.title || isLoading,
      builder: (context, state) => MTextFormField(
        label: 'Broadcast title',
        hint: "Jim Halpert's live audio",
        required: true,
        enabled: !isLoading,
        textInputAction: TextInputAction.next,
        onChanged: context.read<BroadcastFormCubit>().titleChanged,
        validator: (_) => state.title.value.fold(
          (exception) => exception.mapOrNull(
            empty: (value) => MErrorMessages.emptyError,
          ),
          (_) => null,
        ),
      ),
    );
  }
}

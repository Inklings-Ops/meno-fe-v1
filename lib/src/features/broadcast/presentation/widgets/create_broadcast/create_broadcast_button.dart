import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class CreateBroadcastButton extends StatelessWidget {
  const CreateBroadcastButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BroadcastFormCubit>();
    final live = context.watch<LiveBloc>();
    final isLoading = live.state is LiveLoading;
    return Container(
      height: 77,
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MPrimaryButton(
            label: 'Start Broadcast',
            loading: isLoading,
            disabled: isLoading || !bloc.state.isFormValid,
            onPressed: () {
              context.read<TimerCubit>().reset();
              context.clearSnackBars();
              FocusScope.of(context).unfocus();
              if (Form.of(context).validate()) {
                live.add(const GoLoading());
                bloc.create();
              }
            },
          ),
        ],
      ),
    );
  }
}

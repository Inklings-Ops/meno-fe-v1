import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class CreateBroadcastButton extends StatelessWidget {
  const CreateBroadcastButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BroadcastFormCubit>();
    return Container(
      height: 77,
      padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MPrimaryButton(
            label: 'Start Broadcast',
            loading: bloc.state.loading,
            disabled: bloc.state.loading || !bloc.state.isFormValid,
            onPressed: () {
              context.clearSnackBars();
              FocusScope.of(context).unfocus();
              if (Form.of(context).validate()) {
                bloc.create();
              }
            },
          ),
        ],
      ),
    );
  }
}

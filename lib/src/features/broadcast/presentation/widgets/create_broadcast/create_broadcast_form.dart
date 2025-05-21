import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

final _formKey = GlobalKey<FormState>();

class CreateBroadcastForm extends HookWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final descController = useTextEditingController();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spaces.verticalSmall,
          const BroadcastAvatarField(),
          Spaces.verticalLarge,
          const BroadcastTitleField(),
          Spaces.verticalXLarge,
          BroadcastDescriptionField(descController),
          Spaces.verticalXLarge,
          const CoHostSection(),
          Spaces.verticalXLarge,
          CreateBroadcastListItem(
            leadingText: 'Remaining time today',
            subtitleText: 'Your daily broadcast time will reset in 24hrs',
            trailing: MText('0hr 30min', style: textTheme.captionRegular),
          ),
          Spaces.verticalXLarge,
          const RecordToggleSwitchField(),
          Spaces.verticalXLarge,
        ],
      ),
    );
  }
}

class StartBroadcastButton extends StatelessWidget {
  const StartBroadcastButton({super.key});

  @override
  Widget build(BuildContext context) {
    final formBloc = context.watch<BroadcastFormCubit>();

    final broadcastBloc = context.watch<BroadcastBloc>();
    final isLoading = broadcastBloc.state.status.isLoading;

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
            disabled: isLoading || !formBloc.state.isFormValid,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // broadcastBloc.add(
                //   BroadcastStartRequested(
                //     title: formBloc.state.title,
                //     description: formBloc.state.description,
                //     artwork: formBloc.state.artwork,
                //     cohosts: formBloc.state.cohosts,
                //   ),
                // );
              }
            },
          ),
        ],
      ),
    );
  }
}

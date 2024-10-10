import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class CreateBroadcastForm extends HookWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final descController = useTextEditingController();
    return Column(
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
    );
  }
}

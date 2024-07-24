import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class CreateBroadcastForm extends HookWidget {
  const CreateBroadcastForm({super.key});

  @override
  Widget build(BuildContext context) {
    final descController = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        $styles.spaces.verticalSmall,
        const BroadcastAvatarField(),
        $styles.spaces.verticalLarge,
        const BroadcastTitleField(),
        24.vSpace,
        BroadcastDescriptionField(descController),
        24.vSpace,
        const CoHostSection(),
        24.vSpace,
        CreateBroadcastListItem(
          leadingText: 'Remaining time today',
          subtitleText: 'Your daily broadcast time will reset in 24hrs',
          trailing: MText('0hr 30min', style: $styles.text.captionRegular),
        ),
        24.vSpace,
        const RecordToggleSwitchField(),
        24.vSpace,
      ],
    );
  }
}

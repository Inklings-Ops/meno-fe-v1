import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class PreStreamDescriptionSection extends StatelessWidget {
  const PreStreamDescriptionSection({super.key, required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(MIcons.menu_03, size: $styles.insets.large),
            $styles.spaces.horizontalSmall,
            MText('Description', style: $styles.text.subheadingMedium),
          ],
        ),
        $styles.spaces.verticalLarge,
        if (broadcast.description?.getOr() != null)
          MText(broadcast.description!.getOr()!),
      ],
    );
  }
}

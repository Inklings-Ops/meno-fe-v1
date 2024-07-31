import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class PreStreamDescriptionSection extends StatelessWidget {
  const PreStreamDescriptionSection({required this.broadcast, super.key});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(MIcons.menu_03, size: Insets.large),
            Spaces.horizontalSmall,
            MText('Description', style: textTheme.subheadingMedium),
          ],
        ),
        Spaces.verticalLarge,
        if (broadcast.description?.getOr() != null)
          MText(broadcast.description!.getOr()!),
      ],
    );
  }
}

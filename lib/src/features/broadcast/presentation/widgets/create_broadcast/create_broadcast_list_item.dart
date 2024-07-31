import 'package:meno_fe_v1/meno.dart';

class CreateBroadcastListItem extends StatelessWidget {

  const CreateBroadcastListItem({
    required this.leadingText, required this.subtitleText, super.key,
    this.trailing,
  });
  final String leadingText;
  final String subtitleText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = MTextTheme.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: theme.disabledColor,
            borderRadius: Corners.small,
          ),
          child: SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MText(leadingText, style: textTheme.captionMedium),
                ),
                Spaces.horizontalLarge,
                trailing ?? const SizedBox(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 18,
          child: MText(subtitleText, style: textTheme.captionRegular),
        ),
      ],
    );
  }
}

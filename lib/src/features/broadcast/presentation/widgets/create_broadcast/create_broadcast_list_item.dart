import 'package:meno_fe_v1/meno.dart';

class CreateBroadcastListItem extends StatelessWidget {
  final String leadingText;
  final String subtitleText;
  final Widget? trailing;

  const CreateBroadcastListItem({
    super.key,
    required this.leadingText,
    required this.subtitleText,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12).radius,
          decoration: BoxDecoration(
            color: theme.disabledColor,
            borderRadius: $styles.radius.small,
          ),
          child: SizedBox(
            height: 24.toScale,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MText(leadingText, style: $styles.text.captionMedium),
                ),
                $styles.spaces.horizontalLarge,
                trailing ?? const SizedBox(),
              ],
            ),
          ),
        ),
        6.vSpace,
        SizedBox(
          height: 18.toScale,
          child: MText(subtitleText, style: $styles.text.captionRegular),
        ),
      ],
    );
  }
}

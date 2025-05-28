import 'package:meno_fe_v1/meno.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.children,
    super.key,
    this.title,
    this.titleContainerHeight,
  });

  final String? title;
  final List<Widget> children;
  final double? titleContainerHeight;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          SizedBox(
            height: titleContainerHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MText(
                  title!,
                  style: textTheme.captionMedium,
                  color: colors.inActive,
                ),
                Spaces.verticalSmall,
              ],
            ),
          ),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
            color: colors.surfaceTint,
          ),
          child: Material(child: Column(children: children)),
        ),
      ],
    );
  }
}

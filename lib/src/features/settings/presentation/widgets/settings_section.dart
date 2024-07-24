import 'package:meno_fe_v1/meno.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MText(
          title,
          style: $styles.text.captionMedium,
          color: colors.inActive,
        ),
        $styles.spaces.verticalSmall,
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(borderRadius: $styles.radius.large),
            color: colors.surfaceTint,
          ),
          child: Material(child: Column(children: children)),
        ),
      ],
    );
  }
}

import 'package:meno_fe_v1/meno.dart';

class ShareProfileButton extends StatelessWidget {
  const ShareProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final colors = MColorScheme.of(context)!;
    const shape = RoundedRectangleBorder(borderRadius: Corners.sm);

    return MSecondaryButton.icon(
      label: 'Share profile',
      icon: Icon(
        MIcons.share,
        color: colors.onBackground,
      ),
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: colors.outlineVariant3!,
        ),
        foregroundColor: colors.onBackground,
        textStyle: textTheme.microMedium,
        shape: shape,
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    const shape = RoundedRectangleBorder(borderRadius: Corners.small);
    final textStyle = MTextTheme.of(context)!.microMedium;
    return SizedBox(
      height: 32,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: MPrimaryButton.icon(
                label: 'Edit profile',
                icon: const Icon(MIcons.edit_05),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  textStyle: textStyle,
                  shape: shape,
                ),
              ),
            ),
            Spaces.horizontalLarge,
            Expanded(
              child: MSecondaryButton.icon(
                label: 'Share profile',
                icon: Icon(
                  MIcons.share,
                  color: colors.onBackground,
                ),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.outlineVariant3!),
                  foregroundColor: colors.onBackground,
                  textStyle: textStyle,
                  shape: shape,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

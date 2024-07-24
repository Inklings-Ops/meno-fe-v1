import 'package:meno_fe_v1/meno.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return SizedBox(
      height: 32.toScale,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).radius,
        child: Row(
          children: [
            Expanded(
              child: MPrimaryButton.icon(
                label: 'Edit profile',
                icon: const Icon(MIcons.edit_05),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: $styles.radius.small,
                  ),
                ),
              ),
            ),
            $styles.spaces.horizontalLarge,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: $styles.radius.small,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';

class AccountUpgradeSection extends StatelessWidget {
  const AccountUpgradeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.toScale,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).radius,
        child: Row(
          children: [
            MTag(title: 'FREE ACCOUNT', height: 24.toScale),
            $styles.spaces.horizontalLarge,
            MTextButton(
              label: 'Upgrade to Premium',
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: $styles.text.captionMedium.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

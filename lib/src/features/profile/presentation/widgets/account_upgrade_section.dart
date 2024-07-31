import 'package:meno_fe_v1/meno.dart';

class AccountUpgradeSection extends StatelessWidget {
  const AccountUpgradeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return SizedBox(
      height: 24,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const MTag(title: 'FREE ACCOUNT', height: 24),
            Spaces.horizontalLarge,
            MTextButton(
              label: 'Upgrade to Premium',
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: textTheme.captionMedium?.copyWith(
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

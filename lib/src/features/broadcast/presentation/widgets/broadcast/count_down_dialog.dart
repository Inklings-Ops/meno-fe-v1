import 'package:meno_fe_v1/meno.dart';

class CountDownDialog extends StatelessWidget {
  const CountDownDialog({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return SizedBox(
      width: 152.toScale,
      height: 196.toScale,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MText(
            'Going Live in...',
            style: $styles.text.heading2Medium,
            color: colors.onPrimary,
          ),
          $styles.spaces.verticalLarge,
          CircleAvatar(
            radius: 72.toScale,
            backgroundColor: colors.primary,
            child: Padding(
              padding: EdgeInsets.all($styles.insets.small),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MText(
                    '3',
                    style: $styles.text.countDown,
                    color: colors.onPrimary,
                  ),
                  $styles.spaces.verticalLarge,
                  MText(
                    'Skip',
                    style: $styles.text.bodyMedium,
                    color: colors.onPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

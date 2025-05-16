import 'package:meno_fe_v1/meno.dart';

class CountDownDialog extends StatelessWidget {
  const CountDownDialog({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;
    return SizedBox(
      width: 152,
      height: 196,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MText(
            'Going Live in...',
            style: textTheme.heading2Medium,
            color: colors.onPrimary,
          ),
          Spaces.verticalLarge,
          CircleAvatar(
            radius: 72,
            backgroundColor: colors.primary,
            child: Padding(
              padding: const EdgeInsets.all(Insets.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MText(
                    '3',
                    style: textTheme.countDown,
                    color: colors.onPrimary,
                  ),
                  Spaces.verticalLarge,
                  MText(
                    'Skip',
                    style: textTheme.bodyMedium,
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

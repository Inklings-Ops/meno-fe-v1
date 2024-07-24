import 'package:meno_fe_v1/meno.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    this.title,
    required this.actionTitle,
    required this.action,
  });

  final String? title;
  final String actionTitle;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Container(
      margin: const EdgeInsets.only(top: 40).radius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(
            height: 120.toScale,
            width: 120.toScale,
          ),
          MText(
            title ?? 'No broadcasts published yet',
            style: $styles.text.captionMedium,
            textAlign: TextAlign.center,
          ),
          $styles.spaces.verticalLarge,
          SizedBox(
            height: 32.toScale,
            child: MSecondaryButton.icon(
              label: 'View $actionTitle',
              icon: Icon(
                MIcons.share,
                color: colorScheme.onBackground,
              ),
              onPressed: action,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ).radius,
                side: BorderSide(color: colorScheme.outlineVariant3!),
                foregroundColor: colorScheme.onBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: $styles.radius.small,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

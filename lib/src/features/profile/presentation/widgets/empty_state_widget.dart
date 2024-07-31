import 'package:meno_fe_v1/meno.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.actionTitle, required this.action, super.key,
    this.title,
  });

  final String? title;
  final String actionTitle;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Assets.images.liveForYou.image(
            height: 120,
            width: 120,
          ),
          MText(
            title ?? 'No broadcasts published yet',
            style: textTheme.captionMedium,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalLarge,
          SizedBox(
            height: 32,
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
                ),
                side: BorderSide(color: colorScheme.outlineVariant3!),
                foregroundColor: colorScheme.onBackground,
                shape: const RoundedRectangleBorder(
                  borderRadius: Corners.small,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

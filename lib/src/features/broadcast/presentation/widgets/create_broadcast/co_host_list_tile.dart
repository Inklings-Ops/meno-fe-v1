import 'package:meno_fe_v1/meno.dart';

class CohostListTile extends StatelessWidget {
  const CohostListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const MAvatar(radius: 24),
          Spaces.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  'Celebration Church International',
                  style: textTheme.captionMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height:3),
                MText('30K Subscribers', style: textTheme.microRegular),
              ],
            ),
          ),
          Spaces.horizontalLarge,
          SizedBox(
            height: 32,
            child: MSecondaryButton(
              label: 'Add as Co-host',
              style: OutlinedButton.styleFrom(
                textStyle: textTheme.microMedium,
                padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
                shape: const RoundedRectangleBorder(
                  borderRadius: Corners.sm,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

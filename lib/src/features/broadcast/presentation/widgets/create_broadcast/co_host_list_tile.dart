import 'package:meno_fe_v1/meno.dart';

class CohostListTile extends StatelessWidget {
  const CohostListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.toScale,
      child: Row(
        children: [
          MAvatar(radius: 24.toScale),
          $styles.spaces.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  'Celebration Church International',
                  style: $styles.text.captionMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                3.vSpace,
                MText('30K Subscribers', style: $styles.text.microRegular),
              ],
            ),
          ),
          $styles.spaces.horizontalLarge,
          SizedBox(
            height: 32.toScale,
            child: MSecondaryButton(
              label: 'Add as Co-host',
              style: OutlinedButton.styleFrom(
                textStyle: $styles.text.microMedium,
                padding: EdgeInsets.symmetric(horizontal: $styles.insets.large),
                shape: RoundedRectangleBorder(
                  borderRadius: $styles.radius.small,
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

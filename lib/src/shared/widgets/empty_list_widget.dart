import 'package:meno_fe_v1/meno.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(
            height: 120.toScale,
            width: 120.toScale,
          ),
          $styles.spaces.verticalMedium,
          MText(
            title ?? 'Nothing to show here',
            style: $styles.text.captionMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(height: 120, width: 120),
          Spaces.verticalMedium,
          MText(
            title ?? 'Nothing to show here',
            style: MTextTheme.of(context)?.captionMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';

class BroadcastTitle extends StatelessWidget {
  const BroadcastTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: $styles.insets.medium),
      child: MText(
        title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: $styles.text.subheadingBold,
      ),
    );
  }
}

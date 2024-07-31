import 'package:meno_fe_v1/meno.dart';

class BroadcastTitle extends StatelessWidget {
  const BroadcastTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.medium),
      child: MText(
        title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: textTheme.subheadingBold,
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';

class BroadcastTitle extends StatelessWidget {
  const BroadcastTitle({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: MText(
        title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: textTheme.subheadingBold,
      ),
    );
  }
}

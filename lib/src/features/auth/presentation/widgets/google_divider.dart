import 'package:meno_fe_v1/meno.dart';

class GoogleDivider extends StatelessWidget {
  const GoogleDivider({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return Row(
      children: [
        const Expanded(child: MDivider()),
        Spaces.horizontalSmall,
        MText(title, style: textTheme.microRegular),
        Spaces.horizontalSmall,
        const Expanded(child: MDivider()),
      ],
    );
  }
}

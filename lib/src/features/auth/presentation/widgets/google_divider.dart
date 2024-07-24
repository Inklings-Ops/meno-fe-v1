import 'package:meno_fe_v1/meno.dart';

class GoogleDivider extends StatelessWidget {
  const GoogleDivider({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: MDivider()),
        $styles.spaces.horizontalSmall,
        MText(title, style: $styles.text.microRegular),
        $styles.spaces.horizontalSmall,
        const Expanded(child: MDivider()),
      ],
    );
  }
}

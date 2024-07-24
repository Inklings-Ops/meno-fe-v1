import 'package:meno_fe_v1/meno.dart';

class MNotesBackButton extends StatelessWidget {
  const MNotesBackButton({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.toScale,
      height: 18.toScale,
      padding: const EdgeInsets.only(left: 16).radius,
      child: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Row(
          children: [
            Icon(MIcons.chevron_left, size: 16.toScale),
            $styles.spaces.horizontalMicro,
            MText(title, style: $styles.text.captionMedium),
          ],
        ),
      ),
    );
  }
}

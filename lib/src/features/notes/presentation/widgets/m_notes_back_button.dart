import 'package:meno_fe_v1/meno.dart';

class MNotesBackButton extends StatelessWidget {
  const MNotesBackButton({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Container(
      width: 56,
      height: 18,
      padding: const EdgeInsets.only(left: 16),
      child: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: Row(
          children: [
            const Icon(MIcons.chevron_left, size: 16),
            Spaces.horizontalMicro,
            MText(title, style: textTheme.captionMedium),
          ],
        ),
      ),
    );
  }
}

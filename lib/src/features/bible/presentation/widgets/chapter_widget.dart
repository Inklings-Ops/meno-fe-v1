import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class ChapterWidget extends StatelessWidget {
  const ChapterWidget({required this.chapter, super.key});

  final int chapter;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    const borderRadius = Corners.sm;

    return InkWell(
      onTap: () {
        context.read<ScripturePickerCubit>().chapterChanged(chapter);
        Navigator.pop(context);
      },
      borderRadius: borderRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: colors.outlineVariant1?.withOpacity(0.5),
        ),
        child: MText('$chapter'),
      ),
    );
  }
}

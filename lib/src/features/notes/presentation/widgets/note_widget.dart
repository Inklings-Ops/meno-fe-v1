import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key, this.onTap, this.selected = false});

  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final background = selected ? colors.primary : colors.inActiveContainer;
    final foreground = selected ? colors.onPrimary : colors.onInActiveContainer;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20).radius,
      child: Container(
        height: 88.toScale,
        padding: const EdgeInsets.all(16).radius,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20).radius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MText(
              'Notes',
              style: $styles.text.captionMedium,
              color: foreground,
            ),
            BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) => MText(
                state.notes.length.toString(),
                style: $styles.text.heading2Medium,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key, this.onTap, this.selected = false});

  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final background = selected ? colors.primary : colors.inActiveContainer;
    final foreground = selected ? colors.onPrimary : colors.onInActiveContainer;

    final loading = context.watch<NotesBloc>().state is NotesLoadInProgress;

    return Skeletonizer(
      enabled: loading,
      child: RawMaterialButton(
        onPressed: loading ? null : onTap,
        child: Container(
          height: 88,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MText(
                'Notes',
                style: textTheme.captionMedium,
                color: foreground,
              ),
              BlocBuilder<NotesBloc, NotesState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) => MText(
                  state.maybeWhen(
                    orElse: () => '0',
                    loadSuccess: (notes) => notes.length.toString(),
                  ),
                  style: textTheme.heading2Medium,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

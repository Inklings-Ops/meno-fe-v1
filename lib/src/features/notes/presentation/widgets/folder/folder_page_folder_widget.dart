import 'package:intl/intl.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class FolderPageFolderWidget extends StatelessWidget {
  const FolderPageFolderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return RawMaterialButton(
      onPressed: null,
      shape: const FolderWidgetBorder(),
      fillColor: colors.primary,
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      child: Container(
        height: 88,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocSelector<FolderBloc, FolderState, String>(
              selector: (state) => state.folder.title.getOr(),
              builder: (context, folderName) => MText(
                folderName,
                style: textTheme.subheadingMedium,
                color: colors.onPrimary,
              ),
            ),
            BlocBuilder<FolderBloc, FolderState>(
              buildWhen: (p, c) => p.notes != c.notes,
              builder: (context, state) => Skeletonizer(
                enabled: state.isLoadingNotes,
                child: MText(
                  _formatNotesNumber(state.notes.length),
                  style: textTheme.captionMedium,
                  color: colors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNotesNumber(int numberOfNotes) {
    return Intl.plural(
      numberOfNotes,
      zero: 'No notes',
      one: '1 note',
      other: '$numberOfNotes items',
    );
  }
}

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/notes_list.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FolderNotesList extends StatelessWidget {
  const FolderNotesList({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderBloc, FolderState>(
      builder: (context, state) {
        if (state.isLoadingNotes) {
          return Skeletonizer(child: NotesList(notes: fakeNotes));
        }

        if (state.exception != null) return const _FailureWidget();

        final notes = state.notes;
        if (notes.isEmpty) return const EmptyFolderPageWidget();

        return NotesList(notes: notes);
      },
    );
  }
}

class _FailureWidget extends StatelessWidget {
  const _FailureWidget();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(Insets.lg),
      child: Column(
        children: [
          const SizedBox(height: 72),
          MText(
            'An error occurred while retrieving the notes. Please, try again?',
            style: textTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalXLarge,
          SizedBox(
            height: 32,
            child: MSecondaryButton.icon(
              label: 'Reload',
              icon: const Icon(Icons.refresh),
              style: OutlinedButton.styleFrom(
                textStyle: textTheme.microMedium,
                foregroundColor: colors.onBackground,
                iconColor: colors.onBackground,
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
                side: BorderSide(
                  color: colors.outlineVariant3!,
                  width: 1.50,
                ),
              ),
              onPressed: () {
                context.read<FolderBloc>().add(const GetFolderNotes());
              },
            ),
          ),
        ],
      ),
    );
  }
}

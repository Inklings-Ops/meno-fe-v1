import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteListWidget extends StatelessWidget {
  const NoteListWidget({
    super.key,
    this.onNoteTap,
    this.showAddButton = false,
  });

  final VoidCallback? onNoteTap;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => state.maybeWhen(
        orElse: () => const MLoadingIndicator.box(),
        failure: (failure) => const NoteListFailureWidget(),
        loadSuccess: (notes) {
          if (notes.isEmpty) return const EmptyNoteListWidget();
          return ListView.separated(
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: notes.length,
            separatorBuilder: (context, index) => Spaces.verticalLarge,
            itemBuilder: (context, index) => NoteCard(
              note: notes[index]!,
              showAddButton: showAddButton,
              onTap: () => _handleOnTapNote(context, note: notes[index]),
            ),
          );
        },
      ),
    );
  }

  dynamic _handleOnTapNote(BuildContext context, {Note? note}) {
    if (onNoteTap != null) {
      return onNoteTap?.call();
    } else {
      return router.push(Routes.noteEditor, extra: note);
    }
  }
}

class NoteListFailureWidget extends StatelessWidget {
  const NoteListFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return Column(
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
            onPressed: () =>
                context.read<NotesBloc>().add(const GetNotesRequested()),
          ),
        ),
      ],
    );
  }
}

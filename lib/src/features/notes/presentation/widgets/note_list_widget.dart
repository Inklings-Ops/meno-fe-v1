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
    final bloc = context.watch<NotesBloc>();

    return BlocListener<NoteFormCubit, NoteFormState>(
      listenWhen: (p, c) => p.option != c.option,
      listener: (context, state) {
        state.option.fold(
          () {},
          (either) => either.fold((l) => null, (newNote) => null),
        );
      },
      child: BlocBuilder<NotesBloc, NotesState>(
        bloc: bloc,
        buildWhen: (p, c) => p != c,
        builder: (context, state) {
          if (state.isLoading) return const MLoadingIndicator.box();

          if (!state.isLoading && state.exception != null) {
            return const NoteListFailureWidget();
          }

          if (state.notes.isEmpty) return const EmptyNoteListWidget();

          return ListView.separated(
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16).radius,
            itemCount: state.notes.length,
            separatorBuilder: (context, index) => $styles.spaces.verticalLarge,
            itemBuilder: (context, index) => NoteCard(
              note: state.notes[index]!,
              showAddButton: showAddButton,
              onTap: () => _handleOnTapNote(context, note: state.notes[index]),
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
      return context.push(Routes.noteEditor, extra: note);
    }
  }
}

class NoteListFailureWidget extends StatelessWidget {
  const NoteListFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Column(
      children: [
        72.vSpace,
        MText(
          'An error occurred while retrieving the notes. Please, reload to try again?',
          style: $styles.text.bodyRegular,
          textAlign: TextAlign.center,
        ),
        24.vSpace,
        SizedBox(
          height: 32.toScale,
          child: MSecondaryButton.icon(
            label: 'Reload',
            icon: const Icon(Icons.refresh),
            style: OutlinedButton.styleFrom(
              textStyle: $styles.text.microMedium,
              foregroundColor: colors.onBackground,
              iconColor: colors.onBackground,
              shape: RoundedRectangleBorder(
                borderRadius: $styles.radius.small,
              ),
              side: BorderSide(
                color: colors.outlineVariant3!,
                width: 1.50.toScale,
              ),
            ),
            onPressed: () =>
                context.read<NotesBloc>().add(const NotesEvent.getNotes()),
          ),
        )
      ],
    );
  }
}

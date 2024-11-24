import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NewNoteActionButton extends StatelessWidget {
  const NewNoteActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        failure: (failure) => const SizedBox(),
        loadSuccess: (notes) {
          if (notes.isEmpty) return const SizedBox();
          return InkWell(
            onTap: () async {
              final bloc = context.read<NotesBloc>();
              final newNote = await router.push<Note?>(Routes.noteEditor);
              if (newNote != null) return bloc.add(NoteReceived(newNote));
            },
            child: Row(
              children: [
                Icon(MIcons.plus, size: 22, color: colors.primary),
                Spaces.horizontalMicro,
                MText(
                  'Add New Note',
                  style: textTheme.captionMedium,
                  color: colors.primary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NotesTab extends HookWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
            child: SearchBar(
              elevation: const WidgetStatePropertyAll(0),
              onChanged: (value) {},
              hintText: 'Search for notes',
              hintStyle: WidgetStatePropertyAll(textTheme.captionRegular),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: Insets.md),
              ),
              leading: const Icon(MIcons.search, size: Insets.lg),
              shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFFC2C7D0)),
                  borderRadius: Corners.sm,
                ),
              ),
            ),
          ),
          Spaces.verticalSmall,
          SizedBox(
            height: 30,
            child: MTextButton.icon(
              label: 'Add new note',
              icon: const Icon(MIcons.plus),
              onPressed: () async {
                final bloc = context.read<NotesBloc>();
                final n = await router.push<Note?>(Routes.notesTabEditorFull);
                if (n != null) return bloc.add(NoteReceived(n));
              },
            ),
          ),
          Spaces.verticalLarge,
          const NoteListWidget(isForLiveScaffold: true),
        ],
      ),
    );
  }
}
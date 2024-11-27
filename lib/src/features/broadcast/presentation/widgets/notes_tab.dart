import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/notes_list.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotesTab extends HookWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final globalNavKey = useMemoized(GlobalKey<NavigatorState>.new);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
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
              onPressed: () {
                globalNavKey.currentState!.context.push(Routes.noteEditor);
              },
            ),
          ),
          Spaces.verticalLarge,
          const NoteListWidget(),
        ],
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => state.maybeWhen(
        orElse: () => Skeletonizer(child: NotesList(notes: fakeNotes)),
        failure: (failure) => const NoteListFailureWidget(),
        loadSuccess: (notes) {
          if (notes.isEmpty) return const EmptyNoteListWidget();
          return NotesList(
            notes: notes,
            onNoteTap: (note) => _onNoteTap(context, note),
            onOptionTap: _onOptionsTap,
          );
        },
      ),
    );
  }

  Future<void> _onNoteTap(BuildContext context, Note note) async {
    final bloc = context.read<NotesBloc>();
    final newNote = await router.push<Note?>(Routes.noteTabEditor, extra: note);
    if (newNote != null) return bloc.add(NoteReceived(newNote));
  }

  Future<void> _onOptionsTap(Note note) {
    return router.push(Routes.noteCardOptionsModal, extra: {'note':note});
  }
}

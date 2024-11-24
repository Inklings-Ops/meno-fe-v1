import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

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
            itemBuilder: (context, index) {
              final note = notes[index]!;
              return NoteCard(
                note: note,
                onTap: () => router.push(Routes.noteTabEditor, extra: note),
              );
            },
          );
        },
      ),
    );
  }
}

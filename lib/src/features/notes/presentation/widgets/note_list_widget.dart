import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoteListWidget extends StatelessWidget {
  const NoteListWidget({super.key, this.showAddButton = false});
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NotesBloc>();
    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => RefreshIndicator.adaptive(
        onRefresh: () async => bloc.add(const GetNotesRequested()),
        child: state.maybeWhen(
          orElse: () => Skeletonizer(child: NotesList(notes: fakeNotes)),
          failure: (failure) => const NoteListFailureWidget(),
          loadSuccess: (notes) {
            if (notes.isEmpty) return const EmptyNoteListWidget();
            return NotesList(notes: notes, showAddButton: showAddButton);
          },
        ),
      ),
    );
  }
}

class NotesList extends StatelessWidget {
  const NotesList({
    required this.notes,
    this.showAddButton = false,
    super.key,
  });

  final List<Note?> notes;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(Insets.lg),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: notes.length,
      separatorBuilder: (context, index) => Spaces.verticalLarge,
      itemBuilder: (context, index) => NoteCard(
        note: notes[index]!,
        showAddButton: showAddButton,
        onTap: () async {
          final bloc = context.read<NotesBloc>();
          final newNote = await router.push<Note?>(
            Routes.noteEditor,
            extra: notes[index],
          );
          if (newNote != null) return bloc.add(NoteReceived(newNote));
        },
      ),
    );
  }
}

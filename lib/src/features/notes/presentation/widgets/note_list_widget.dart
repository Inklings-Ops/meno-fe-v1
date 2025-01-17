import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/notes_list.dart';

class NoteListWidget extends StatelessWidget {
  const NoteListWidget({
    super.key,
    this.showAddButton = false,
    this.isForLiveScaffold = false,
  });

  final bool showAddButton;

  /// Flag to set when the notes list is to be displayed from a Live
  /// Broadcast or Live Stream scaffold.
  final bool isForLiveScaffold;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NotesBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) => RefreshIndicator.adaptive(
          onRefresh: () async => bloc.add(const GetNotesRequested()),
          child: state.maybeWhen(
            orElse: () => Skeletonizer(child: NotesList(notes: fakeNotes)),
            failure: (failure) => const NoteListFailureWidget(),
            loadSuccess: (notes) {
              if (notes.isEmpty) return const EmptyNoteListWidget();
              return NotesList(
                notes: notes,
                showAddButton: showAddButton,
                onNoteTap: (note) => _onNoteTap(context, note),
                onOptionTap: _onOptionsTap,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onNoteTap(BuildContext context, Note note) async {
    final bloc = context.read<NotesBloc>();
    Note? newN;

    if (isForLiveScaffold) {
      newN = await router.push<Note?>(Routes.notesTabEditorFull, extra: note);
    } else {
      newN = await router.push<Note?>(Routes.noteEditor, extra: note);
    }

    if (newN != null) return bloc.add(NoteReceived(newN));
  }

  Future<void> _onOptionsTap(Note note) {
    return router.push(Routes.noteCardOptionsModal, extra: {'note': note});
  }
}

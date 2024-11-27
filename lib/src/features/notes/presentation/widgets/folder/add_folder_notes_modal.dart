import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/notes_list.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddNotesToFolderModal extends HookWidget {
  const AddNotesToFolderModal({required this.folder, super.key});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final watcher = context.watch<NotesWatcherBloc>();

    final selectedNote = useState<Note?>(null);

    return BlocListener<NotesWatcherBloc, NotesWatcherState>(
      listener: (context, state) {
        state.whenOrNull(
          failure: context.showNoteError,
          noteAddedToFolder: (note, folder) {
            context.read<NotesBloc>().add(const GetNotesRequested());
            context.read<FoldersBloc>().add(UpdateFolderList(folder));
            router.pop(note);
          },
        );
      },
      child: MModal(
        title: 'Add to Folder',
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spaces.verticalLarge,
            Expanded(child: _NotesList(selectedNote: selectedNote)),
            Spaces.verticalLarge,
            MPrimaryButton(
              label: 'Done',
              loading: watcher.state is NoteWatcherLoading,
              disabled: selectedNote.value == null,
              onPressed: () {
                watcher.add(AddNoteToFolder(selectedNote.value!, folder));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList({required this.selectedNote});
  final ValueNotifier<Note?> selectedNote;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) => state.maybeWhen(
        orElse: () => const EmptyNoteListWidget(),
        loadInProgress: () => Skeletonizer(child: NotesList(notes: fakeNotes)),
        failure: (failure) => const NoteListFailureWidget(),
        loadSuccess: (notes) => NotesList(
          notes: notes.where((e) => e?.folder == null).toList(),
          selectedNote: selectedNote.value,
          showAddButton: true,
          onNoteTap: (note) {
            if (selectedNote.value != null) {
              selectedNote.value = null;
            } else {
              selectedNote.value = note;
            }
          },
        ),
      ),
    );
  }
}

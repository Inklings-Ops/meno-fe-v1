import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/notes_list.dart';

class AddNotesToFolderModal extends HookWidget {
  const AddNotesToFolderModal({required this.folder, super.key});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final watcher = context.watch<NotesWatcherBloc>();

    final selectedNote = useState<Note?>(null);

    return BlocListener<NotesWatcherBloc, NotesWatcherState>(
      listener: (ctx, state) {
        switch (state) {
          case NotesWatcherLoadFailed(:final exception):
            ctx.showErrorSnackBar(exception.message);
          case NotesWatcherNoteAddedToFolder(:final note, :final folder):
            ctx.read<NotesBloc>().add(const NotesFetchNotesRequested());
            ctx.read<FoldersBloc>().add(FoldersUpdateFoldersRequested(folder));
            router.pop(note);
          default:
        }
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
              loading: watcher.state is NotesWatcherLoadInProgress,
              disabled: selectedNote.value == null,
              onPressed: () {
                watcher.add(
                  NotesWatcherAddNoteToFolderRequested(
                    selectedNote.value!,
                    folder,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesList extends StatefulWidget {
  const _NotesList({required this.selectedNote});
  final ValueNotifier<Note?> selectedNote;

  @override
  State<_NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<_NotesList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NotesBloc>().add(const NotesFetchMoreNotesRequested());
    }
  }

  // Helper to check if scroll position is near the bottom
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        switch (state.status) {
          case NotesStatus.initial:
          case NotesStatus.loading:
            return Skeletonizer(child: NotesList(notes: fakeNotes));
          case NotesStatus.failure:
            return const NoteListFailureWidget();
          case NotesStatus.loadingMore:
          case NotesStatus.loadSuccess:
            if (state.notes.isEmpty) return const EmptyNoteListWidget();
            return NotesList(
              notes: state.notes.where((n) => n?.folder == null).toList(),
              selectedNote: widget.selectedNote.value,
              showAddButton: true,
              hasReachedMax: state.hasReachedMax,
              scrollController: _scrollController,
              bottomWidget: (state.status == NotesStatus.loadingMore)
                  ? const MLoadingIndicator.four()
                  : null,
              onNoteTap: (note) {
                if (widget.selectedNote.value != null) {
                  widget.selectedNote.value = null;
                } else {
                  widget.selectedNote.value = note;
                }
              },
            );
        }
      },
    );
  }
}

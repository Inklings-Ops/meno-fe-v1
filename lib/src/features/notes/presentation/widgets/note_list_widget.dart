import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/notes_list.dart';

class NoteListWidget extends StatefulWidget {
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
  State<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
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
    if (_isBottom) context.read<NotesBloc>().add(const FetchMoreNotes());
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
    final bloc = context.read<NotesBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: RefreshIndicator(
        onRefresh: () async => bloc.add(const GetNotesRequested()),
        child: BlocBuilder<NotesBloc, NotesState>(
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
                  notes: state.notes,
                  hasReachedMax: state.hasReachedMax,
                  scrollController: _scrollController,
                  showAddButton: widget.showAddButton,
                  onNoteTap: (note) => _onNoteTap(context, note),
                  onOptionTap: _onOptionsTap,
                  bottomWidget: (state.status == NotesStatus.loadingMore)
                      ? const MLoadingIndicator.four()
                      : null,
                );
            }
          },
        ),
      ),
    );
  }

  Future<void> _onNoteTap(BuildContext context, Note note) async {
    final bloc = context.read<NotesBloc>();
    Note? newN;

    if (widget.isForLiveScaffold) {
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

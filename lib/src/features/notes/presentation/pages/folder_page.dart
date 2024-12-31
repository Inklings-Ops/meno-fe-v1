import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class FolderPage extends HookWidget {
  const FolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasNotes = context.select((FolderBloc b) => b.state.notes.isNotEmpty);
    final bloc = context.watch<FolderBloc>();
    final watcher = context.watch<NotesWatcherBloc>();
    return RefreshIndicator(
      onRefresh: () async => bloc.add(const GetFolderNotes()),
      child: BlocListener<NotesWatcherBloc, NotesWatcherState>(
        bloc: watcher,
        listenWhen: (p, c) =>
            p is NoteAddedToFolder != c is NoteAddedToFolder ||
            p is NoteRemovedFromFolder != c is NoteRemovedFromFolder,
        listener: (context, state) {
          watcher.state.whenOrNull(
            noteAddedToFolder: (note, _) {
              bloc.add(UpdateFolderNotes(note));
            },
            noteRemovedFromFolder: (note, _) {
              bloc.add(UpdateFolderNotes(note));
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 42,
            leadingWidth: 90,
            leading: const MNotesBackButton(title: 'Folders'),
            actions: const [FolderPageOptionsButton()],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FolderPageFolderWidget(),
                Spaces.verticalLarge,
                if (hasNotes) ...[
                  const FolderPageSearchBox(),
                  Spaces.verticalLarge,
                ],
                const FolderNotesList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FolderPageOptionsButton extends StatelessWidget {
  const FolderPageOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final folder = context.select((FolderBloc bloc) => bloc.state.folder);

    return IconButton(
      icon: const Icon(MIcons.dots_horizontal),
      onPressed: () => context.showModal<void>(
        BlocProvider.value(
          value: context.read<FolderBloc>(),
          child: MModal(
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MModalListTile(
                  leading: const Icon(MIcons.file_plus_02),
                  title: 'Add Notes',
                  onTap: () async => _addNotes(context, folder),
                ),
                Spaces.verticalSmall,
                MModalListTile(
                  leading: const Icon(MIcons.edit_05),
                  title: 'Rename Folder',
                  onTap: () async => _renameFolder(context, folder),
                ),
                Spaces.verticalSmall,
                MModalListTile(
                  leading: Icon(MIcons.trash, color: colors.error),
                  title: 'Delete',
                  titleColor: colors.error,
                  onTap: () async => _deleteFolder(context, folder),
                ),
                Spaces.verticalLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNotes(BuildContext context, Folder folder) async {
    final r = await router.push<bool>(Routes.notesModal, extra: folder);
    if (r == false) return;
    return router.pop();
  }
  
  Future<void> _deleteFolder(BuildContext context, Folder f) async {
    final r = await router.push<bool>(Routes.deleteFolderDialog, extra: f);
    if (r == false) return;
    router
      ..pop()
      ..pop();
  }

  Future<void> _renameFolder(BuildContext context, Folder folder) async {
    final bloc = context.read<FolderBloc>();
    final r = await router.push<Folder?>(Routes.folderFormModal, extra: folder);
    if (r == null) return;
    bloc.add(RenameFolder(r));
    return router.pop();
  }
}

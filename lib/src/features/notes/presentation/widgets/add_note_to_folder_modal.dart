import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class AddNoteToFolderModal extends HookWidget {
  const AddNoteToFolderModal({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final watcher = context.watch<NotesWatcherBloc>();
    final loading = watcher.state is NoteWatcherLoading;

    final selectedFolder = useState<Folder?>(null);

    return BlocListener<NotesWatcherBloc, NotesWatcherState>(
      listener: (context, state) {
        state.whenOrNull(
          noteAddedToFolder: (note, folder) {
            context.read<NotesBloc>().add(NoteReceived(note));
            router.pop(note);
          },
        );
      },
      child: MModal(
        title: 'Add to Folder',
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BlocBuilder<FoldersBloc, FoldersState>(
                buildWhen: (p, c) => p != c,
                builder: (context, state) => state.when(
                  failed: (_) => const FolderListFailureWidget(),
                  loading: () => const MLoadingIndicator.box(),
                  loaded: (folders) {
                    if (folders.isEmpty) return const EmptyFolderListWidget();
                    return ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: folders.length,
                      separatorBuilder: (_, i) => Spaces.verticalLarge,
                      itemBuilder: (context, i) {
                        final folder = folders[i];
                        return FolderListTile(
                          folder: folder!,
                          selected: selectedFolder.value?.id == folder.id,
                          onTap: !loading
                              ? () => selectedFolder.value = folder
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            if (selectedFolder.value != null) ...[
              Spaces.verticalLarge,
              MPrimaryButton(
                label: 'Done',
                loading: loading,
                disabled: selectedFolder.value == null,
                onPressed: () {
                  watcher.add(AddNoteToFolder(note, selectedFolder.value!));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class AddNoteToFolderModal extends HookWidget {
  const AddNoteToFolderModal({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final watcher = context.watch<NotesWatcherBloc>();
    final loading = watcher.state is NotesWatcherLoadInProgress;

    final pickedFolder = useState<Folder?>(null);

    return BlocListener<NotesWatcherBloc, NotesWatcherState>(
      listener: (context, state) {
        switch (state) {
          case NotesWatcherNoteAddedToFolder(:final note):
            context.read<NotesBloc>().add(NotesNoteReceived(note));
            context.read<FoldersBloc>().add(const FoldersGetFoldersRequested());
            router.pop(true);
          case NotesWatcherLoadFailed(:final exception):
            context.showErrorSnackBar(exception.message);
            router.pop(false);
          default:
        }
      },
      child: MModal(
        title: 'Add to Folder',
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BlocBuilder<FoldersBloc, FoldersState>(
                buildWhen: (p, c) => p != c,
                builder: (context, state) {
                  final folders = state.folders;
                  switch (state.status) {
                    case FoldersStatus.initial:
                    case FoldersStatus.failure:
                      return const FolderListFailureWidget();
                    case FoldersStatus.loading:
                      return const MLoadingIndicator.box();
                    case FoldersStatus.loadingMore:
                    case FoldersStatus.success:
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
                            isSelected: pickedFolder.value?.id == folder.id,
                            onTap: !loading
                                ? () => pickedFolder.value = folder
                                : null,
                          );
                        },
                      );
                  }
                },
              ),
            ),
            if (pickedFolder.value != null) ...[
              Spaces.verticalLarge,
              MPrimaryButton(
                label: 'Done',
                loading: loading,
                disabled: pickedFolder.value == null,
                onPressed: () => watcher.add(
                  NotesWatcherAddNoteToFolderRequested(
                    note,
                    pickedFolder.value!,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

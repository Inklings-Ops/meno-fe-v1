import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class MoveNoteToFolderModal extends HookWidget {
  const MoveNoteToFolderModal({
    required this.note,
    required this.folderId,
    super.key,
  });

  final Note note;
  final Uid<Folder> folderId;

  @override
  Widget build(BuildContext context) {
    final watcher = context.watch<NotesWatcherBloc>();
    final loading = watcher.state is NoteWatcherLoading;

    final pickedF = useState<Folder?>(null);

    return BlocListener<NotesWatcherBloc, NotesWatcherState>(
      listener: (context, state) {
        state.whenOrNull(
          noteAddedToFolder: (note, folder) {
            context.read<NotesBloc>().add(NoteReceived(note));
            context.read<FoldersBloc>().add(const GetAllFolders());
            router.pop(true);
          },
          failure: (exception) {
            context.showNoteError(exception);
            router.pop(false);
          },
        );
      },
      child: MModal(
        title: 'Move Note',
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
                    final list =
                        folders.where((f) => f?.id != folderId).toList();
                    return ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: list.length,
                      separatorBuilder: (_, i) => Spaces.verticalLarge,
                      itemBuilder: (context, i) {
                        final folder = list[i];
                        return FolderListTile(
                          folder: folder!,
                          isSelected: pickedF.value?.id == folder.id,
                          onTap: !loading ? () => pickedF.value = folder : null,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            if (pickedF.value != null) ...[
              Spaces.verticalLarge,
              MPrimaryButton.icon(
                label: 'Move to folder',
                icon: const Icon(MIcons.arrow_narrow_right),
                iconPlacement: MButtonIconPlacement.right,
                loading: loading,
                disabled: pickedF.value == null,
                onPressed: () => watcher.add(
                  AddNoteToFolder(note, pickedF.value!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

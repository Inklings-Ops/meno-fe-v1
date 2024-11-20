import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class AddToFolderModal extends HookWidget {
  const AddToFolderModal({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final noteListBloc = context.watch<NotesBloc>();
    final folderListBloc = context.watch<FolderListBloc>();

    final selectedFolder = useState<Folder?>(null);

    return BlocListener<NotesBloc, NotesState>(
      bloc: noteListBloc,
      listenWhen: (p, c) => p != c,
      listener: (context, state) {
        // if (selectedFolder.value != null) {
        //   state.whenOrNull(
        //     success: (_) {
        //       folderListBloc.add(const FolderListEvent.getAllFolders());
        //       context.pop();
        //       context.pop();
        //     },
        //   );
        // }
      },
      child: MModal(
        title: 'Add to Folder',
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BlocBuilder<FolderListBloc, FolderListState>(
                bloc: folderListBloc,
                buildWhen: (p, c) => p != c,
                builder: (context, state) => state.when(
                  failure: (_) => const FolderListFailureWidget(),
                  loading: () => const MLoadingIndicator.box(),
                  success: (folders) {
                    if (folders.isEmpty) {
                      return const EmptyFolderListWidget();
                    }

                    return ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: folders.length,
                      separatorBuilder: (_, i) => Spaces.verticalLarge,
                      itemBuilder: (context, i) {
                        final folder = folders[i]!;
                        return FolderListTile(
                          folder: folder,
                          selected: selectedFolder.value?.id == folder.id,
                          onTap: () => selectedFolder.value = folder,
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
                loading: noteListBloc.state is NotesLoadInProgress,
                onPressed: () {
                  // TODO:
                  // noteListBloc.add(
                  //   NotesEvent.addToFolder(selectedFolder.value!, note),
                  // );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

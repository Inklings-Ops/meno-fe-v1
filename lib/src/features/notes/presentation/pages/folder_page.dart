import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';


class FolderPage extends HookWidget {
  const FolderPage({required this.folder, super.key});
  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final updatedFolder = useState(folder);
    final isNewFolder = updatedFolder.value != folder;

    final folderBloc = context.read<FolderCubit>();

    final numberOfNotes = (isNewFolder
            ? updatedFolder.value.numberOfNotes
            : folder.numberOfNotes) ??
        0;

    useEffect(
      () {
        context.read<FolderCubit>().getAllNotes();
        return null;
      },
      const [],
    );

    return RefreshIndicator(
      onRefresh: folderBloc.getAllNotes,
      child: BlocListener<FolderFormCubit, FolderFormState>(
        listenWhen: (p, c) => p.option != c.option,
        listener: (context, state) {
          state.option.fold(
            () => null,
            (either) => either.fold(
              (_) => null,
              (newFolder) => updatedFolder.value = newFolder,
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 42,
            leadingWidth: 90,
            leading: const MNotesBackButton(title: 'Folders'),
            actions: [
              IconButton(
                icon: const Icon(MIcons.dots_horizontal),
                onPressed: () => context.showModal<void>(
                  MModal(
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MModalListTile(
                          leading: const Icon(MIcons.edit_05),
                          title: 'Rename Folder',
                          onTap: () => context
                            ..pop()
                            ..showModal<void>(
                              CreateFolderModal(initialFolder: folder),
                              isScrollControlled: true,
                              useRootNavigator: true,
                            ),
                        ),
                        Spaces.verticalSmall,
                        MModalListTile(
                          leading: Icon(MIcons.trash, color: colors.error),
                          title: 'Delete',
                          titleColor: colors.error,
                          onTap: () => context.showDeleteFolderDialog(
                            updatedFolder.value,
                          ),
                        ),
                        Spaces.verticalLarge,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                FolderWidget(
                  value: '$numberOfNotes notes',
                  title: isNewFolder
                      ? updatedFolder.value.title.getOr()
                      : folder.title.getOr(),
                  titleStyle: textTheme.subheadingMedium,
                  valueStyle: textTheme.captionMedium,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  height: 88,
                ),
                Spaces.verticalXLarge,
                _NotesList(folder: folder),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList({required this.folder});
  final Folder folder;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderCubit, FolderState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        loading: () => const MLoadingIndicator.four(),
        success: (folder) {
          if (folder.notes == null || folder.notes?.isEmpty == true) {
            return EmptyFolderPageWidget(folder: folder);
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, i) => Spaces.verticalLarge,
            itemCount: folder.notes!.length,
            itemBuilder: (context, i) => NoteCard(
              note: folder.notes![i]!,
              folder: folder,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

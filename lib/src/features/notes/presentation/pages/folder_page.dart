import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/folder/folder_notes_list.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/folder/folder_page_folder_widget.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/folder/folder_page_search_box.dart';

class FolderPage extends HookWidget {
  const FolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FolderCubit>();
    final hasNoNotes = context.select<FolderCubit, bool>(
      (bloc) => bloc.state.maybeWhen(
        orElse: () => true,
        loaded: (folder) => folder.notes == null || folder.notes!.isEmpty,
      ),
    );

    return RefreshIndicator(
      onRefresh: bloc.getAllNotes,
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
              if (hasNoNotes)
                Spaces.verticalLarge
              else ...[
                Spaces.verticalLarge,
                const FolderPageSearchBox(),
                Spaces.verticalLarge,
              ],
              const FolderNotesList(),
            ],
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
    final folder = context.select<FolderCubit, Folder?>(
      (bloc) => bloc.state.whenOrNull(loaded: (folder) => folder),
    );
    return IconButton(
      icon: const Icon(MIcons.dots_horizontal),
      onPressed: () => context.showModal<void>(
        BlocProvider.value(
          value: context.read<FolderCubit>(),
          child: MModal(
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MModalListTile(
                  leading: const Icon(MIcons.edit_05),
                  title: 'Rename Folder',
                  onTap: folder != null
                      ? () async => _rename(context, folder)
                      : null,
                ),
                Spaces.verticalSmall,
                MModalListTile(
                  leading: Icon(MIcons.trash, color: colors.error),
                  title: 'Delete',
                  titleColor: colors.error,
                  onTap: folder != null
                      ? () => context.showDeleteFolderDialog(folder)
                      : null,
                ),
                Spaces.verticalLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _rename(BuildContext context, Folder folder) async {
    final bloc = context.read<FolderCubit>();
    final r = await router.push<Folder?>(Routes.folderFormModal, extra: folder);
    if (r == null) return;
    bloc.renameFolder(r);
    return router.pop();
  }
}

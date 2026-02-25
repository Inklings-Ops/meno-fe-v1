import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FolderListWidget extends WatchingWidget {
  const FolderListWidget({super.key});

  @override
  Widget build(BuildContext ctx) {
    final textTheme = MTextTheme.of(ctx);

    final error = watchValue((FoldersManager m) => m.error);
    final folders = watchValue((FoldersManager m) => m.folders);
    final isLoading = watchValue((FoldersManager m) => m.initialize.isRunning);

    const padding = EdgeInsets.all(Insets.lg);

    if (isLoading) return Skeletonizer(child: FolderList(folders: fakeFolders));

    if (error != null && folders.isEmpty) {
      return const Padding(padding: padding, child: NoteListFailureWidget());
    }

    if (error == null && folders.isEmpty) {
      return Padding(
        padding: padding,
        child: MText(
          'No folders found',
          style: textTheme.bodyRegular,
          textAlign: TextAlign.center,
        ),
      );
    }

    return FolderList(
      folders: folders,
      onTap: (folder) => ctx.push(R.folder(folder.id.getOrCrash())),
      onOptionsTap: (folder) => _OptionsModal.show(ctx, folder),
    );
  }
}

class _OptionsModal extends WatchingWidget {
  const _OptionsModal._({required this.folder}) : super(key: null);

  final NoteFolder folder;

  static Future<dynamic> show(BuildContext context, NoteFolder folder) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => _OptionsModal._(folder: folder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return MModal(
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MModalListTile(
            leading: const Icon(MIcons.file_plus_02),
            title: 'Add Notes',
            onTap: () => _addNoteToFolder(context),
          ),
          Spaces.verticalSmall,
          MModalListTile(
            leading: const Icon(MIcons.edit_05),
            title: 'Rename Folder',
            onTap: () => FolderEditorModal.show(ctx, folder.id.getOrCrash()),
          ),
          Spaces.verticalSmall,
          MModalListTile(
            leading: Icon(MIcons.trash, color: colors.error),
            title: 'Delete',
            titleColor: colors.error,
            onTap: () => _deleteFolder(context),
          ),
          Spaces.verticalSmall,
        ],
      ),
    );
  }

  Future<void> _addNoteToFolder(BuildContext context) async {
    final folderId = folder.id;
    final results = await SelectNotesModal.show(context, folderId);
    if (results == null || results.isEmpty) return;
    di<NoteActionsManager>().assignNotesToFolder.run((
      noteIds: results,
      targetFolderId: folderId,
    ));
    if (context.mounted) context.pop();
  }

  Future<void> _deleteFolder(BuildContext context) async {
    final result = await DeleteAlertDialog.show(
      context,
      title: 'Delete Folder?',
      description: 'Do want to delete this folder?',
    );

    if (result == false) return;
    di<FoldersManager>().deleteFolder.run(folder.id);
    if (context.mounted) context.pop();
  }
}

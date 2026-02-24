import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/entities/note_folder.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno/shared/presentation/widgets/delete_alert_dialog.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderCardOptionsModal extends WatchingWidget {
  const FolderCardOptionsModal({required this.folder, super.key});

  final NoteFolder folder;

  static Future<dynamic> show(BuildContext context, NoteFolder folder) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => FolderCardOptionsModal(folder: folder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    registerHandler(
      select: (FoldersManager m) => m.deleteFolder,
      handler: (context, newValue, cancel) {
        if (newValue ?? false) context.pop();
      },
    );

    return MModal(
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MModalListTile(
            leading: const Icon(MIcons.file_plus_02),
            title: 'Add Notes',
            onTap: () {},
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

  Future<void> _deleteFolder(BuildContext context) async {
    final result = await DeleteAlertDialog.show(
      context,
      title: 'Delete Folder?',
      description: 'Do want to delete this folder?',
    );

    if (result ?? false) {
      di<FoldersManager>().deleteFolder.run(folder.id);
      if (context.mounted) context.pop();
    }
  }
}

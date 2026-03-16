import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/widgets/delete_alert_dialog.dart';
import 'package:meno/features/notes/manager/_manager.dart';
import 'package:meno/features/notes/model/entities/note_folder.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FolderListWidget extends WatchingWidget {
  const FolderListWidget({
    super.key,
    this.physics,
    this.controller,
    this.primary,
    this.isNested = false,
  });

  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;
  final bool isNested;

  @override
  Widget build(BuildContext ctx) {
    final folders = watchValue((FoldersManager m) => m.folders);
    final isLoading = watchValue((FoldersManager m) => m.initialize.isRunning);

    if (isLoading) return Skeletonizer(child: FolderList(folders: fakeFolders));

    return CustomScrollView(
      primary: primary,
      controller: controller,
      physics: physics,
      slivers: [
        if (isNested)
          Builder(
            builder: (context) => SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
          ),
        SliverPadding(
          padding: const .all(16),
          sliver: SliverList.separated(
            itemCount: folders.length,
            separatorBuilder: (_, __) => Spaces.verticalLarge,
            itemBuilder: (context, index) {
              final folder = folders[index];
              return FolderCard(
                folder: folder,
                onTap: () => ctx.push(R.folder(folder.id.getOrCrash())),
                onOptionsTap: () => _OptionsModal.show(ctx, folder),
              );
            },
          ),
        ),
      ],
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

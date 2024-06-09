import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/domain/domain.dart';
import 'package:meno_fe_v1/src/features/notes/presentation/widgets/add_to_folder_modal.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class NoteCardOptionsModal extends StatelessWidget {
  const NoteCardOptionsModal({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (note.folder != null)
            MModalListTile(
              leading: const Icon(MIcons.plus),
              title: 'Remove from Folder',
              onTap: () => context.showRemoveNoteFromFolderDialog(note),
            )
          else
            MModalListTile(
              leading: const Icon(MIcons.plus),
              title: 'Add to Folder',
              onTap: () => context.showModal(
                AddToFolderModal(note: note),
                useRootNavigator: true,
                isScrollControlled: true,
              ),
            ),
          MCore.small.verticalSpace,
          const MModalListTile(
            leading: Icon(MIcons.share),
            title: 'Share',
          ),
          MCore.small.verticalSpace,
          const MModalListTile(
            leading: Icon(MIcons.link_02),
            title: 'Copy Link',
          ),
          MCore.small.verticalSpace,
          MModalListTile(
            leading: Icon(MIcons.trash, color: colors.error),
            title: 'Delete',
            titleColor: colors.error,
            onTap: () => context.showDeleteNoteDialog(note),
          ),
          MCore.small.verticalSpace,
        ],
      ),
    );
  }
}

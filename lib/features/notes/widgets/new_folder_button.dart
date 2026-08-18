import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/notes.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NewFolderButton extends WatchingWidget {
  const NewFolderButton._({required this.isAction, this.onTap});

  const NewFolderButton.outlined({void Function()? onTap})
    : this._(isAction: false, onTap: onTap);

  const NewFolderButton.action({void Function()? onTap})
    : this._(isAction: true, onTap: onTap);

  final void Function()? onTap;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    final totalCount = watchValue((FoldersManager m) => m.totalFoldersCount);

    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    if (isAction) {
      if (totalCount < 1) return const SizedBox.shrink();

      return InkWell(
        onTap: () => FolderEditorModal.show(context),
        child: Row(
          children: [
            Icon(MIcons.plus, size: 22, color: colors.primary),
            Spaces.horizontalMicro,
            MText(
              'Add New Folder',
              style: textTheme.captionMedium,
              color: colors.primary,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 139,
      height: 32,
      child: MSecondaryButton.icon(
        label: 'Create New Folder',
        icon: const Icon(MIcons.plus),
        style: OutlinedButton.styleFrom(
          textStyle: textTheme.microMedium,
          foregroundColor: colors.onBackground,
          iconColor: colors.onBackground,
          shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
          side: BorderSide(color: colors.outlineVariant3, width: 1.50),
        ),
        onPressed: () => FolderEditorModal.show(context),
      ),
    );
  }
}

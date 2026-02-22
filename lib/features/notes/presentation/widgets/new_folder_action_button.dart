import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NewFolderActionButton extends WatchingWidget {
  const NewFolderActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final totalCount = watchValue((FoldersManager m) => m.totalFoldersCount);
    if (totalCount < 1) const SizedBox.shrink();

    // Only show the add button if there already folders in the list
    return InkWell(
      onTap: () {},
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
}

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NewNoteActionButton extends WatchingWidget {
  const NewNoteActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final totalCount = watchValue((NotesManager m) => m.totalNotesCount);
    if (totalCount < 1) const SizedBox.shrink();

    // Only show the add button if there already notes in the list
    return InkWell(
      onTap: () => context.pushNamed(
        R.noteEditorName,
        pathParameters: {'noteId': 'new'},
      ),
      child: Row(
        children: [
          Icon(MIcons.plus, size: 22, color: colors.primary),
          Spaces.horizontalMicro,
          MText(
            'Add New Note',
            style: textTheme.captionMedium,
            color: colors.primary,
          ),
        ],
      ),
    );
  }
}

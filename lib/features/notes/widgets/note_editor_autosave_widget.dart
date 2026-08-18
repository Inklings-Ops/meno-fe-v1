import 'package:flutter/material.dart';
import 'package:meno/features/notes/manager/note_editor_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NoteEditorAutosaveWidget extends StatelessWidget {
  const NoteEditorAutosaveWidget({required this.status, super.key});

  final NoteEditorStatus status;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final colors = MColorScheme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: switch (status) {
        NoteEditorStatus.saving => MText(
          'Saving…',
          key: const ValueKey('saving'),
          color: colors.primary,
          style: textTheme.captionMedium,
        ),
        NoteEditorStatus.saved => MText(
          'Saved',
          key: const ValueKey('saved'),
          color: colors.onBackgroundVariant,
          style: textTheme.captionMedium,
        ),
        NoteEditorStatus.failure => MText(
          'Save failed',
          key: const ValueKey('failure'),
          color: colors.error,
          style: textTheme.captionMedium,
        ),
        _ => const SizedBox.shrink(key: ValueKey('none')),
      },
    );
  }
}

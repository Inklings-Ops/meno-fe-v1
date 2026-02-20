import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NoteEditorAutosaveWidget extends StatelessWidget {
  const NoteEditorAutosaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MText(
      'Saving...',
      color: MColorScheme.of(context).primary,
      style: MTextTheme.of(context).captionMedium,
    );
  }
}

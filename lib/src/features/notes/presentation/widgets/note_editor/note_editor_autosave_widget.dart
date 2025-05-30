import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteEditorAutosaveWidget extends StatelessWidget {
  const NoteEditorAutosaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorBloc, NoteEditorState>(
      buildWhen: (p, c) =>
          p is NoteEditorSaveInProgress != c is NoteEditorSaveInProgress,
      builder: (context, state) => switch (state) {
        NoteEditorSaveInProgress() => MText(
            'Saving...',
            color: MColorScheme.of(context).primary,
            style: MTextTheme.of(context).captionMedium,
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

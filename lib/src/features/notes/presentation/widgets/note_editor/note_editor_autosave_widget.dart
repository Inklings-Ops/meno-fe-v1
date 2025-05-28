import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteEditorAutosaveWidget extends StatelessWidget {
  const NoteEditorAutosaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorBloc, NoteEditorState>(
      buildWhen: (p, c) => p is NoteSaveInProgress != c is NoteSaveInProgress,
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        saving: () => MText(
          'Saving...',
          color: MColorScheme.of(context).primary,
          style: MTextTheme.of(context).captionMedium,
        ),
      ),
    );
  }
}

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteEditorAutosaveWidget extends StatelessWidget {
  const NoteEditorAutosaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NoteEditorBloc>();

    return BlocBuilder<NoteEditorBloc, NoteEditorState>(
      buildWhen: (p, c) => p is NoteSaveInProgress != c is NoteSaveInProgress,
      builder: (context, state) => InkWell(
        onTap: () => state.whenOrNull(
          loaded: (_) => bloc.add(const NoteSaveRequested()),
        ),
        child: MText(
          state.maybeWhen(orElse: () => 'Done', saving: () => 'Saving...'),
          color: MColorScheme.of(context).primary,
          style: MTextTheme.of(context)!.captionMedium,
        ),
      ),
    );
  }
}

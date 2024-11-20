import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteEditorAutosaveWidget extends StatelessWidget {
  const NoteEditorAutosaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NoteEditorBloc>();

    return BlocBuilder<NoteEditorBloc, NoteEditorState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        final loading = state.status == NoteEditorStatus.loading;
        return InkWell(
          onTap: loading ? null : () => bloc.add(const NoteSaveRequested()),
          child: MText(
            loading ? 'Saving...' : 'Done',
            color: MColorScheme.of(context)!.primary,
            style: MTextTheme.of(context)!.captionMedium,
          ),
        );
      },
    );
  }
}

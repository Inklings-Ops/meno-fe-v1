import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteEditorPage extends HookWidget {
  const NoteEditorPage({required this.note, super.key});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final isSaving = useState<bool>(false);
    final isSaved = useState<bool>(false);
    final bloc = context.read<NoteEditorBloc>();

    return BlocConsumer<NoteEditorBloc, NoteEditorState>(
      listenWhen: (p, c) =>
          p is NoteEditorSaveInProgress != c is NoteEditorSaveInProgress,
      listener: (context, state) {
        switch (state) {
          case NoteEditorFailure(:final exception):
            context.showErrorSnackBar(exception.message);
          case NoteEditorSaveSuccess(:final note):
            if (note.id.isValid == false) return router.pop(note);
          default:
        }
      },
      builder: (context, state) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          isSaving.value = true;

          if (isSaved.value) return;

          isSaved.value = true;

          // Allow popping if no change is made to the note
          if ((state as NoteEditorLoadSuccess).note == note) {
            return router.pop();
          }

          // Allow popping if the note's title and content are empty, initially
          // or after editing.
          if (bloc.isNoteEmpty) return router.pop();

          // Save the note
          bloc.add(const NoteEditorSaveRequested());

          // If the note exists, pop the route with the note as result after
          // editing
          if (bloc.isDoneEditingAndValid) return router.pop(state.note);
        },
        child: NoteEditorWidget(note: note),
      ),
    );
  }
}
